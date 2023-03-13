part of 'audio_list_bloc.dart';

class AudioListState {
  const AudioListState({
    this.mapDeletedAudio = const [],
    this.listDeletedAudio = const [],
    this.pathToAudioForShare = '',
    this.audioList = const [],
    this.titleOfAudio = '',
    this.totalDuration = '',
    this.rename = false,
    this.counterAudio = '',
    this.selectedModels = const [],
    this.selectedModelsId = const [],
    this.uuid = '',
  });

  final List<AudioModel> audioList;
  final String titleOfAudio;
  final String totalDuration;
  final bool rename;
  final String counterAudio;
  final String pathToAudioForShare;
  final List<AudioModel> listDeletedAudio;
  final List<Map> mapDeletedAudio;
  final List selectedModels;
  final List<String> selectedModelsId;
  final String uuid;


  AudioListState copyWith({
    String? uuid,
    List<AudioModel>? audioList,
    String? titleOfAudio,
    String? totalDuration,
    bool? rename,
    String? counterAudio,
    String? pathToAudioForShare,
    List<AudioModel>? listDeletedAudio,
    List<Map>? mapDeletedAudio,
    List? selectedModels,
    List<String>? selectedModelsId,
  }) {
    return AudioListState(
      uuid: uuid ?? this.uuid,
      audioList: audioList ?? this.audioList,
      titleOfAudio: titleOfAudio ?? this.titleOfAudio,
      totalDuration: totalDuration ?? this.totalDuration,
      rename: rename ?? this.rename,
      counterAudio: counterAudio ?? this.counterAudio,
      pathToAudioForShare: pathToAudioForShare ?? this.pathToAudioForShare,
      listDeletedAudio: listDeletedAudio ?? this.listDeletedAudio,
      mapDeletedAudio: mapDeletedAudio ?? this.mapDeletedAudio,
      selectedModels: selectedModels ?? this.selectedModels,
      selectedModelsId: selectedModelsId ?? this.selectedModelsId,
    );
  }
}
