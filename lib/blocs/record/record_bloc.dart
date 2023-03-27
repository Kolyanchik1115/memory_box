import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/repository/record_repository.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:uuid/uuid.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  RecordBloc() : super(const RecordState()) {
    final RecordRepository _recordRepository = RecordRepository();

    _recordRepository.initRecorder();

    on<RecordTickEvent>((event, emit) {
      emit(state.copyWith(
        noiseValues: event.noiseValues,
        timer: event.timer,
        status: RecorderStatus.play,
      ));
    });

    on<RecordStartedEvent>((event, emit) async {
      String timer = '00:00:00';
      List<double> noiseValues = [];
      final timerFormat = TimerFormat();
      // int? timeMinutes;

      await _recordRepository.record();

      _recordRepository.recorder!.onProgress!.listen((value) {
        double? decibels = value.decibels;
        timer = timerFormat.format(value.duration, recorder: true);
        _recordRepository.timerAudio = timerFormat.format(value.duration);
        // timeMinutes = value.duration.inMinutes;
        _recordRepository.recordDurationSeconds = value.duration.inSeconds;
        if (decibels! > 25) {
          noiseValues.add((decibels - 25) * 2);
        } else {
          noiseValues.add(0);
        }
        if (noiseValues.length > 80) {
          noiseValues = noiseValues.getRange(1, noiseValues.length).toList();
        }

        add(
          RecordTickEvent(noiseValues, timer),
        );
      });
    });

    on<RecorderStoppedEvent>((event, emit) async {
      const uuid = Uuid();
      final String audioId = uuid.v4();
      await _recordRepository.stop(audioId);
      emit(state.copyWith(uuid: audioId, status: RecorderStatus.finish));
      _recordRepository.dispose();
    });

    on<RecordCancelEvent>((event, emit) {});
  }
}
