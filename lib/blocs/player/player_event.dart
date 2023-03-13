part of 'player_bloc.dart';

abstract class PlayerEvent {}

class PlayerGetModelEvent extends PlayerEvent {
  PlayerGetModelEvent({required this.listAudioModels});

  final List<AudioModel> listAudioModels;
}

class PlayerInitialUuidEvent extends PlayerEvent {
   PlayerInitialUuidEvent(this.uuid);

  final String uuid;
}

class GetModelFromFirebase extends PlayerEvent {
   GetModelFromFirebase(
    this.uuid,
  );

  final String uuid;
}

class PlayerRenameEvent extends PlayerEvent {
   PlayerRenameEvent({required this.uuid, required this.titleOfAudio});

  final String uuid;
  final String titleOfAudio;
}

class PlayerPauseEvent extends PlayerEvent {}

class PlayerStopEvent extends PlayerEvent {}

class PlayerInitOverlayEvent extends PlayerEvent {
   PlayerInitOverlayEvent(this.path, this.titleOfAudio);

  final String path;
  final String titleOfAudio;
}

class PlayerStartOverlayEvent extends PlayerEvent {}

class PlayerBackEvent extends PlayerEvent {}

class PlayerForwardEvent extends PlayerEvent {}

class PlayerDownloadEvent extends PlayerEvent {}

class PlayerPauseResumeEvent extends PlayerEvent {}

class PlayerInitEvent extends PlayerEvent {
   PlayerInitEvent();
}

class PlayerStartEvent extends PlayerEvent {
   PlayerStartEvent(this.uuid);

  final String uuid;
}

class PlayerPositionEvent extends PlayerEvent {
   PlayerPositionEvent(
    this.value,
  );

  final double value;
}

class PlayerTickEvent extends PlayerEvent {
   PlayerTickEvent(
    this.durationView,
    this.positionView,
    this.duration,
    this.position,
  );

  final String durationView;
  final String positionView;
  final Duration duration;
  final Duration position;
}
