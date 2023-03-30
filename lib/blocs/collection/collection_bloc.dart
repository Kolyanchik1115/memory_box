import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/models/collection_model.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'collection_event.dart';

part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  CollectionBloc() : super(const CollectionState()) {
    on<InitCollectionCardEvent>((event, emit) async {
      final List<AudioModel> getAudioModels = await getListAudioHelper();
      final List<AudioModel> sortAudioModelsById = collectionModels
          .idAudioModels
          .map((id) => getAudioModels.firstWhere((element) => id == element.id))
          .toList();
      emit(state.copyWith(
        audioIds: sortAudioModelsById,
      ));
    });

    on<CollectionGetCardInitial>((event, emit) async {
      collectionModels = event.collectionAudioModel;

      final List<AudioModel> getAudioModels = await getListAudioHelper();
      final List<AudioModel> sortAudioModelsById = collectionModels
          .idAudioModels
          .map((id) => getAudioModels.firstWhere((element) => id == element.id))
          .toList();

      emit(state.copyWith(
        collectionAudioModel: event.collectionAudioModel,
        counterAudio: event.collectionAudioModel.idAudioModels.length,
        audioIds: sortAudioModelsById,
        titleOfCollection: event.collectionAudioModel.titleOfCollection,
        descriptionOfCollection: event.collectionAudioModel.descriptionOfAudio,
        pathToImage: event.collectionAudioModel.pathToImage,
        allTimeAudioCollection:
            event.collectionAudioModel.allTimeAudioCollection,
        createTime: event.collectionAudioModel.createTime,
      ));
    });

    on<ChangeImageCollectionCardEvent>((event, emit) async {
      final String pathToImage = await _pickImage();
      print(pathToImage);
      emit(state.copyWith(
        pathToImage: pathToImage,
      ));
    });

    on<ChangeTitleCollectionCardEvent>((event, emit) {
      titleOfCollection = event.titleOfCollection;
      state.copyWith(
        titleOfCollection: event.titleOfCollection,
      );
    });
    on<ChangeDescriptionCollectionCardEvent>((event, emit) {
      descriptionOfCollection = event.descriptionOfCollection;
      print(event.descriptionOfCollection);
      state.copyWith(
        descriptionOfCollection: event.descriptionOfCollection,
      );
    });
    on<SaveEditedCollectionCardEvent>((event, emit) async {
      final String uuidCollection = state.collectionAudioModel.id;
      await updateCard(uuidCollection);
    });
    on<DeleteCollectionCardEvent>((event, emit) {
      final String uuidModel = state.collectionAudioModel.id;
      _deleteAudio(uuidModel);
    });

    on<GetIdAudioEvent>((event, emit) {
      AudioId.audioId = event.audioAddId;
      AudioId.audioInSeconds = event.audioInSeconds;
      state.copyWith(
        audioAddId: getId,
      );
    });
    on<SelectCollection>((event, emit) {
      if (selectedCollection.contains(event.collectionAddId) &&
          selectedCollection.isNotEmpty) {
        selectedCollection.remove(event.collectionAddId);
        print(selectedCollection);
      } else {
        selectedCollection.add(event.collectionAddId!);
        print(selectedCollection);
      }
      state.copyWith(collectionAddId: event.collectionAddId);
    });
    on<AddToCollectionAudioEvent>((event, emit) async {
      selectedCollection.forEach(_addAudioToCollection);
      selectedCollection.clear();
    });
    on<DeleteAudioCollectionEvent>((event, emit) async {
      final audioId = event.uuidAudio;
      final idCollection = state.collectionAudioModel.id;

      await _deleteAudioCollection(idCollection, audioId);
    });
    on<AddAnyCollectionCardEvent>((event, emit) async {
      final List? audioIds = AudioId.audioIdList;
      for (var audio in audioIds!) {
        for (var collection in selectedCollection) {
          await _addAnyAudioToCollection(collection, audio);
        }
      }
      selectedCollection.clear();
    });
    on<ShareCollectionCardEvent>((event, emit) {
      String shareLink = _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('collectionList')
          .doc(state.collectionAudioModel.id)
          .path;
      Share.share(shareLink);
    });
  }

  String? getId;
  List<String> selectedCollection = [];

  late CollectionAudioModel collectionModels;
  String? descriptionOfCollection;
  String? titleOfCollection;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteAudioCollection(
      String collectionId, String audioId) async {
    final int durationAudio = await FirebaseFirestore.instance
        .collection('audioList')
        .doc(audioId)
        .get()
        .then((value) => value.data()!['recordDurationSeconds']);
    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('collectionList')
        .doc(collectionId)
        .update({
      'idAudioModels': FieldValue.arrayRemove([audioId]),
      'allTimeAudioCollection': FieldValue.increment(-durationAudio),
    });
  }

  Future<void> _addAudioToCollection(String id) async {
    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('collectionList')
        .doc(id)
        .update({
      'idAudioModels': FieldValue.arrayUnion([AudioId.audioId]),
      'allTimeAudioCollection': FieldValue.increment(AudioId.audioInSeconds!),
    });
  }

  Future<void> _addAnyAudioToCollection(
    String collectionId,
    String audioId,
  ) async {
    await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('collectionList')
        .doc(collectionId)
        .update({
      'idAudioModels': FieldValue.arrayUnion([audioId]),
    });
  }

  Future _pickImage() async {
    final picker = ImagePicker();
    File imageFile;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);
    final path = await _uploadImage(imageFile);
    return path;
  }

  Future<void> updateImage(String uuid, String path) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('collectionList');
    await collection.doc(uuid).update({'pathToImage': path});

    log('update: done!');
  }

  Future<String> _uploadImage(File image) async {
    final nameImage = generateRandomString();
    final ref = _storage.ref().child('image/$nameImage.jpg');
    final uploadTask =
        ref.putFile(image, SettableMetadata(contentType: 'image/jpg'));
    final snapshot = await uploadTask.whenComplete(() {});
    final urlFirestore = await snapshot.ref.getDownloadURL();
    return urlFirestore;
  }

  Future _deleteAudio(String uuid) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('collectionList');
    await collection.doc(uuid).delete();
  }

  Future<void> updateCard(String uuid) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('collectionList');
    await collection.doc(uuid).update({
      'pathToImage': state.pathToImage,
      'titleOfCollection': titleOfCollection,
      'descriptionOfAudio': descriptionOfCollection,
    });
    log('update: done!');
  }

  Future<String> renameAudio(String uuid, String renameAudio) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    await collection.doc(uuid).update({'titleOfAudio': renameAudio});
    return renameAudio;
  }
}
