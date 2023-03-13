part of 'audio_list_bloc.dart';

abstract class AudioListEvent {}

class AudioListCollectionSelectedEvent extends AudioListEvent {}

class AudioListInitialEvent extends AudioListEvent {}

class AudioListPlayer extends AudioListEvent {}

class AudioListRemoveSelectedEvent extends AudioListEvent {}

class AudioListRestoreSelectedEvent extends AudioListEvent {}

class AudioListItemRemoveEvent extends AudioListEvent {}

class AudioListShareEvent extends AudioListEvent {}

class AudioListItemShareEvent extends AudioListEvent {}

class AudioListItemRemoveInNewFolderEvent extends AudioListEvent {}

class AudioListDeleteFromCollectionEvent extends AudioListEvent {}

class AudioListShareCollectionEvent extends AudioListEvent {}

class AudioListDownloadCollectionEvent extends AudioListEvent {}

class AudioListPlayEvent extends AudioListEvent {
  AudioListPlayEvent({required this.playAudio});

  final bool playAudio;
}

class AudioListItemInteractionEvent extends AudioListEvent {
  AudioListItemInteractionEvent(
    this.audioIndex,
    this.uuid,
  );
  final String uuid;
  final int audioIndex;
}

class AudioListItemDeselectEvent extends AudioListEvent {
  AudioListItemDeselectEvent(
    this.index,
    this.id,
  );

  final int index;
  final String id;
}

class AudioListItemSelectEvent extends AudioListEvent {
  AudioListItemSelectEvent(
    this.index,
    this.id,
  );

  final int index;
  final String id;
}

class AudioListItemRenameEvent extends AudioListEvent {
  AudioListItemRenameEvent({this.titleOfAudio});

  final String? titleOfAudio;
}
