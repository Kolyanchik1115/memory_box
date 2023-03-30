import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/models/collection_model.dart';
import 'package:memory_box/repository/auth_repository.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'create_collection_event.dart';

part 'create_collection_state.dart';

class CreateCollectionBloc extends Bloc<CreateCollectionEvent, CreateCollectionState> {
  CreateCollectionBloc() : super(const CreateCollectionState()) {
    on<CreateCollectionNameEvent>(
      (event, emit) async {
        titleOfCollection = event.titleOfCollection;
        emit(
          state.copyWith(
            titleOfCollection: event.titleOfCollection,
          ),
        );
      },
    );

    on<CreateCollectionDescriptionEvent>(
      (event, emit) {
        final id = getId();
        final createTime = dateNow();
        descriptionOfCollection = event.descriptionOfCollection;
        emit(
          state.copyWith(
            id: id,
            createTime: createTime,
            descriptionOfAudio: event.descriptionOfCollection,
          ),
        );
      },
    );

    on<CreateCollectionSaveEvent>(
      (event, emit) async {
        await _uploadFirestore();
        clearState();

      },
    );
    on<CreateCollectionUploadImageEvent>((event, emit) async {
      final String image = await pickImage();
      emit(state.copyWith(
        image: image,
      ));
    });
    on<CreateCollectionAddAudioEvent>((event, emit) async {
      collectionModels = await getListCollectionHelper();
      final List<AudioModel> getAudioModels = await getListAudioHelper();
      audioId = event.id!;
      print(' In collection : $audioId ');
      for (var audio in audioId) {
        audioModels.add(
          getAudioModels.firstWhere((element) => element.id == audio),
        );
      }
      final totalDurationFromAudioModel = audioModels.map((e) => e.recordDurationSeconds);
      final sumTime = totalDurationFromAudioModel.reduce((value, element) => value + element);
      // final totalDuration = allAudioTime(totalDurationFromAudioModel);
      emit(state.copyWith(
        idAudioModels: audioId,
        audioModels: audioModels,
        allTimeAudioCollection: sumTime,
      ));
    });
    on<CollectionInitialEvent>((event, emit) async {
      if(isAuth()){

      } else {
        collectionModels = await getListCollectionHelper();
        emit(state.copyWith(
          listCollectionModels: collectionModels,
        ));
      }

    });


    on<CollectionItemInteractionEvent>((event, emit) {
      index = event.collectionIndex;
    });
  }

  List<AudioModel> listAudioModels = [];
  int? index;
  List<CollectionAudioModel> collectionModels = [];
  List<AudioModel> audioModels = [];
  List <String>audioId = [];
  String? localPathToImage;
  String? titleOfCollection;
  String? descriptionOfCollection;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> _uploadFirestore() async {
    final createTime = dateNow();
    final id = getId();
    final collectionModel = CollectionAudioModel(
      id: id,
      createTime: createTime,
      titleOfCollection: state.titleOfCollection,
      allTimeAudioCollection: state.allTimeAudioCollection,
      idAudioModels: audioId,
      pathToImage: state.image,
      descriptionOfAudio: state.descriptionOfAudio,
    );
    final createCollectionModel = collectionModel.toJson();
    final CollectionReference collectionList = _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('collectionList');
    await collectionList.doc(id).set(createCollectionModel);
  }


  Future pickImage() async {
    final picker = ImagePicker();
    File imageFile;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);
    final path = await _uploadImage(imageFile);
    return path;
  }
  Future<String> _uploadImage(File image) async {
    final nameImage = generateRandomString();
    final ref = _storage.ref().child('image/$nameImage.jpg');
    final uploadTask = ref.putFile(image, SettableMetadata(contentType: 'image/jpg'));
    final snapshot = await uploadTask.whenComplete(() {});
    final urlFirestore = await snapshot.ref.getDownloadURL();
    return urlFirestore;
  }
  void clearState(){
    emit(CreateCollectionState());
    audioId.clear();
    collectionModels.clear();
  }

}


