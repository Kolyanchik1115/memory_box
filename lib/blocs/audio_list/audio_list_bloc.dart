import 'package:file_saver/file_saver.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/repository/audio_list_repository.dart';
import 'package:memory_box/repository/firebase_repository.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:share_plus/share_plus.dart';

part 'audio_list_event.dart';
part 'audio_list_state.dart';

class AudioListBloc extends Bloc<AudioListEvent, AudioListState> {
  final AudiolistRepository _audiolistRepository = AudiolistRepository();
  String? uuid;
  List listSelected = [];
  List<String> listSelectedId = [];

  AudioListBloc() : super(const AudioListState()) {
    on<AudioListInitialEvent>((event, emit) async {
      if (isAuth()) {
      } else {
        _audiolistRepository.listDeletedAudio =
            await _audiolistRepository.getDeletedList();
        _audiolistRepository.listNotDeletedAudio =
            await _audiolistRepository.getNotDeletedList();
        final counterAudio =
            _audiolistRepository.listNotDeletedAudio.length.toString();
        final totalDurationFromAudioModel = _audiolistRepository
            .listNotDeletedAudio
            .map((e) => e.durationOfAudio);
        final mapDeletedAudio = _audiolistRepository.listDeletedAudio
            .map((e) => e.toJson())
            .toList();
        final totalDuration = allAudioTime(totalDurationFromAudioModel);

        emit(state.copyWith(
          audioList: _audiolistRepository.listNotDeletedAudio,
          totalDuration: totalDuration,
          counterAudio: counterAudio,
          listDeletedAudio: _audiolistRepository.listDeletedAudio,
          mapDeletedAudio: mapDeletedAudio,
        ));
      }
    });

    on<AudioListItemRenameEvent>((event, emit) async {
      await renameAudio(uuid!, event.titleOfAudio!);
      add(AudioListInitialEvent());
    });

    on<AudioListItemInteractionEvent>((event, emit) async {
      uuid = event.uuid;
    });
    on<AudioListItemRemoveInNewFolderEvent>((event, emit) async {
      _audiolistRepository.listNotDeletedAudio =
          await _audiolistRepository.getNotDeletedList();
      await _audiolistRepository.deleteAudioId(uuid!);
      await _audiolistRepository.deleteInNewFolder(uuid!);
      add(AudioListInitialEvent());
    });

    on<AudioListItemRemoveEvent>((event, emit) async {
      _audiolistRepository.listDeletedAudio =
          await _audiolistRepository.getDeletedList();
      await _audiolistRepository.deleteAudioId(uuid!);

      add(AudioListInitialEvent());
    });

    on<AudioListItemShareEvent>((event, emit) async {
      final String pathAudio = await _audiolistRepository.pathAudio(uuid!);
      await Share.share(pathAudio);
    });

    on<AudioListItemSelectEvent>((event, emit) async {
      listSelectedId.add(event.id);
      AudioId.audioIdList.add(event.id);
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
    });
    on<AudioListRemoveSelectedEvent>((event, emit) {
      listSelected.forEach(_audiolistRepository.deleteToIndex);
      listSelected = [];
      add(AudioListInitialEvent());
    });
    on<AudioListRestoreSelectedEvent>((event, emit) {
      listSelected.forEach(_audiolistRepository.restoreToIndex);
      listSelected = [];
      add(AudioListInitialEvent());
    });
    on<AudioListCollectionSelectedEvent>((event, emit) {
      listSelected.forEach(_audiolistRepository.getListIdToIndex);
    });
    on<AudioListDeleteFromCollectionEvent>((event, emit) {
      listSelectedId.forEach(_audiolistRepository.deleteAudioId);
      listSelectedId = [];
      listSelected = [];
    });
    on<AudioListShareEvent>((event, emit) async {
      String pathAudio = await _audiolistRepository.pathAudio(uuid!);
      await Share.share(pathAudio);
    });
    on<AudioListShareCollectionEvent>((event, emit) async {
      List<String> paths = [];
      for (var element = 0; element < listSelectedId.length; element++) {
        paths
            .add(await _audiolistRepository.pathAudio(listSelectedId[element]));
      }

      await Share.share(paths.join(', '));
    });

    on<AudioListDownloadCollectionEvent>((event, emit) async {
      for (var element = 0; element < listSelectedId.length; element++) {
        Uint8List? audioFile;
        String nameAudio =
            await _audiolistRepository.nameAudio(listSelectedId[element]);
        final pathReference = FirebaseStorage.instance.refFromURL(
            await _audiolistRepository.pathAudio(listSelectedId[element]));
        audioFile = await pathReference.getData();
        String format = '.mp3';
        MimeType mimeType = MimeType.MP3;
        await FileSaver.instance
            .saveAs(nameAudio, audioFile!, format, mimeType);
      }
      listSelectedId = [];
    });
  }
}
