import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/repository/firebase_repository.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:share_plus/share_plus.dart';

part 'audio_list_event.dart';
part 'audio_list_state.dart';

class AudioListBloc extends Bloc<AudioListEvent, AudioListState> {
  AudioListBloc() : super(const AudioListState()) {
    on<AudioListInitialEvent>((event, emit) async {
      if (isAuth()) {
      } else {
        listDeletedAudio = await _getDeletedList();
        listNotDeletedAudio = await _getNotDeletedList();
        final counterAudio = listNotDeletedAudio.length.toString();
        final totalDurationFromAudioModel =
            listNotDeletedAudio.map((e) => e.durationOfAudio);
        final mapDeletedAudio =
            listDeletedAudio.map((e) => e.toJson()).toList();
        final totalDuration = allAudioTime(totalDurationFromAudioModel);
        log('AppInformation: Refresh audio list');
        emit(state.copyWith(
          audioList: listNotDeletedAudio,
          totalDuration: totalDuration,
          counterAudio: counterAudio,
          listDeletedAudio: listDeletedAudio,
          mapDeletedAudio: mapDeletedAudio,
        ));
      }
    });

    on<AudioListItemRenameEvent>((event, emit) async {
      await renameAudio(uuid!, event.titleOfAudio!);
      add(AudioListInitialEvent());
    });

    on<AudioListItemInteractionEvent>((event, emit) async {
      print(event.uuid);
      uuid = event.uuid;
      currentIndex = event.audioIndex;
    });
    on<AudioListItemRemoveInNewFolderEvent>((event, emit) async {
      listNotDeletedAudio = await _getNotDeletedList();
      await deleteAudio(uuid!);
      await _deleteInNewFolder(uuid!);
      add(AudioListInitialEvent());
    });

    on<AudioListItemRemoveEvent>((event, emit) async {
      listDeletedAudio = await _getDeletedList();

      await _deleteAudio(uuid!);

      add(AudioListInitialEvent());
    });

    on<AudioListItemShareEvent>((event, emit) async {
      final String pathAudio = await _pathAudio(uuid!);
      await Share.share(pathAudio);
    });

    on<AudioListItemSelectEvent>((event, emit) async {
      listSelectedId.add(event.id);

      AudioId.audioIdList.add(event.id);
      print(AudioId.audioIdList);
      listSelected.add(event.index);

      emit(state.copyWith(
        selectedModels: listSelected,
        selectedModelsId: listSelectedId,
      ));
    });
    on<AudioListItemDeselectEvent>((event, emit) {
      listSelected.remove(event.index);
      listSelectedId.remove(event.id);
      AudioId.audioIdList.remove(event.id);
      print(AudioId.audioIdList);
    });
    on<AudioListRemoveSelectedEvent>((event, emit) {
      listSelected.forEach(_deleteToIndex);
      listSelected = [];
      add(AudioListInitialEvent());
    });
    on<AudioListRestoreSelectedEvent>((event, emit) {
      listSelected.forEach(_restoreToIndex);
      listSelected = [];
      add(AudioListInitialEvent());
    });
    on<AudioListCollectionSelectedEvent>((event, emit) {
      listSelected.forEach(_getListIdToIndex);
      print(listSelected);
    });
    on<AudioListDeleteFromCollectionEvent>((event, emit) {
      listSelectedId.forEach(deleteAudio);
      listSelectedId = [];
      listSelected = [];
    });
    on<AudioListShareEvent>((event, emit) async {
      String pathAudio = await _pathAudio(uuid!);
      await Share.share(pathAudio);
    });
    on<AudioListShareCollectionEvent>((event, emit) async {
      List<String> paths = [];
      for (var element = 0; element < listSelectedId.length; element++) {
        paths.add(await _pathAudio(listSelectedId[element]));
      }

      await Share.share(paths.join(', '));
    });
    on<AudioListDownloadCollectionEvent>((event, emit) async {
      for (var element = 0; element < listSelectedId.length; element++) {
        Uint8List? audioFile;
        String nameAudio = await _nameAudio(listSelectedId[element]);
        final pathReference = FirebaseStorage.instance
            .refFromURL(await _pathAudio(listSelectedId[element]));
        audioFile = await pathReference.getData();
        String format = '.mp3';
        MimeType mimeType = MimeType.MP3;
        await FileSaver.instance
            .saveAs(nameAudio, audioFile!, format, mimeType);
      }
      listSelectedId = [];
    });
  }

  String? uuid;
  List<String> listSelectedId = [];
  List listSelected = [];
  int? currentIndex;
  List<AudioModel> listDeletedAudio = [];
  List<AudioModel> listNotDeletedAudio = [];

  Future _pathAudio(String id) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    final path =
        await collection.doc(id).get().then((value) => value.data()!['path']);
    return path;
  }

  Future _nameAudio(String id) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    final path = await collection
        .doc(id)
        .get()
        .then((value) => value.data()!['titleOfAudio'
            '']);
    return path;
  }

  Future<void> deleteAudio(audioId) async {
    final int durationAudio = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .doc(audioId)
        .get()
        .then((value) => value.data()!['recordDurationSeconds']);

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('collectionList')
        .where('idAudioModels', arrayContains: audioId)
        .get();
    for (var element in snapshot.docs) {
      await element.reference.update({
        'idAudioModels': FieldValue.arrayRemove([audioId]),
        'allTimeAudioCollection': FieldValue.increment(-durationAudio),
      });
    }
  }

  Future _deleteAudio(String uuid) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    await collection.doc(uuid).delete();
  }

  Future _deleteInNewFolder(String uuid) async {
    final dateTimeNow = DateTime.now();
    final dateFormat = DateFormat('dd.MM.yy');
    final dateDeletedNow = dateFormat.format(dateTimeNow);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .doc(uuid)
        .update({
      'removedStatus': true,
      'deleteTime': dateDeletedNow,
    });
  }

  Future _getNotDeletedList() async {
    final sort = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .where('removedStatus', isEqualTo: false)
        .get()
        .then((value) => value.docs);
    listNotDeletedAudio =
        sort.map((e) => AudioModel.fromJson(e.data())).toList();
    return listNotDeletedAudio;
  }

  Future _getDeletedList() async {
    final sort = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .where('removedStatus', isEqualTo: true)
        .get()
        .then((value) => value.docs);
    listDeletedAudio = sort.map((e) => AudioModel.fromJson(e.data())).toList();
    return listDeletedAudio;
  }

  Future _deleteToIndex(index) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    await collection.doc(listDeletedAudio[index!].id).delete();
  }

  Future _getListIdToIndex(index) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    final id = collection.doc(listDeletedAudio[index!].id).get().toString();
    return id;
  }

  Future _restoreToIndex(index) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    await collection.doc(listDeletedAudio[index!].id).update({
      'removedStatus': false,
    });
  }
}
