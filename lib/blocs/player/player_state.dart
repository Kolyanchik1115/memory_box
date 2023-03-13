part of 'player_bloc.dart';

enum PlayerStatus { play, stop, loading, loaded }

class PlayersState {
  const PlayersState({
    this.audioModel,
    this.uuid = '',
    this.durationView = '00:00',
    this.positionView = '00:00',
    this.duration = const Duration(),
    this.position = const Duration(),
    this.status = PlayerStatus.stop,
    this.path = '',

    this.isPause = false,
    this.fileName = '',
    this.usingPlayer = false,
    this.isPlaying = false,
    this.id = '',
  });

  final String durationView;
  final String positionView;
  final Duration duration;
  final Duration position;
  final String path;
  final String id;

  final bool isPause;
  final String fileName;
  final bool usingPlayer;
  final PlayerStatus status;
  final String uuid;
  final AudioModel? audioModel;
  final bool isPlaying;

  PlayersState copyWith({
    String? id,
    String? path,
    String? durationView,
    String? positionView,
    Duration? duration,
    Duration? position,
    bool isPause = false,
    String? fileName,
    bool? usingPlayer,
    PlayerStatus? status,
    String? uuid,
    AudioModel? audioModel,
    bool? isPlaying,
  }) {
    return PlayersState(
      id: id ?? this.id,
      path: path ?? this.path,
      durationView: durationView ?? this.durationView,
      positionView: positionView ?? this.positionView,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      fileName: fileName ?? this.fileName,
      usingPlayer: usingPlayer ?? this.usingPlayer,
      status: status ?? this.status,
      isPause: isPause,
      uuid: uuid ?? this.uuid,
      audioModel: audioModel ?? this.audioModel,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
