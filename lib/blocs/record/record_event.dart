part of 'record_bloc.dart';

class RecordEvent {
  const RecordEvent();
}

class RecordCancelEvent extends RecordEvent {}

class RecordStartedEvent extends RecordEvent {}

class RecorderStoppedEvent extends RecordEvent {}

class RecordTickEvent extends RecordEvent {
  const RecordTickEvent(
    this.noiseValues,
    this.timer,
  );

  final List<double> noiseValues;
  final String timer;
}
