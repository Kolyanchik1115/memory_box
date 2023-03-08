part of 'record_bloc.dart';

enum RecorderStatus { play, stop, finish }

@immutable
class RecordState {
  const RecordState({
    this.uuid = '',
    this.noiseValues = const [],
    this.timer = '00:00:00',
    this.status = RecorderStatus.stop,
  });

  final List<double> noiseValues;
  final String timer;
  final RecorderStatus status;
  final String uuid;

  RecordState copyWith({
    List<double>? noiseValues,
    String? timer,
    RecorderStatus? status,
    String? uuid,
  }) {
    return RecordState(
      noiseValues: noiseValues ?? this.noiseValues,
      timer: timer ?? this.timer,
      status: status ?? this.status,
      uuid: uuid ?? this.uuid,
    );
  }
}
