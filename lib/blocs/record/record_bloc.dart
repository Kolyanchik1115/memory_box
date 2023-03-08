import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/utils/helpers.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  RecordBloc() : super(const RecordState()) {
    initRecorder();

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

      _isRun = true;

      await record();

      _recorder!.onProgress!.listen((value) {
        double? decibels = value.decibels;
        timer = timerFormat.format(value.duration, recorder: true);
        timerAudio = timerFormat.format(value.duration);
        timeMinutes = value.duration.inMinutes;
        recordDurationSeconds = value.duration.inSeconds;
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
      _isRun = true;
      const uuid = Uuid();
      final String audioId = uuid.v4();
      await stop(audioId);
      emit(state.copyWith(uuid: audioId, status: RecorderStatus.finish));
      _dispose();
    });
    on<RecordCancelEvent>((event, emit) {});
  }

  int? recordDurationSeconds;
  late String timerAudio;
  int? timeMinutes;
  FlutterSoundRecorder? _recorder;
  bool _isRecorderReady = false;
  final String audio = 'Аудиозапись  ';
  final timerFormat = TimerFormat();
  bool _isRun = false;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String nameAudio = 'Аудиозаписьь';

  void _dispose() {
    if (!_isRecorderReady) return;
    _recorder!.closeRecorder();
    _recorder = null;
    _isRecorderReady = false;
  }

  Future initRecorder() async {
    _recorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await _recorder!.openRecorder();

    _isRecorderReady = true;
    _recorder!.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future stop(String audioId) async {
    if (!_isRecorderReady) return;
    final path = await _recorder?.stopRecorder();
    final audioFile = File(path!);
    print('ПУТЬ! $audioFile');
    if(isAuth()){

    } else {
      final audioPath = await _uploadAudio(audioFile);
      await _uploadFirestore(audioPath, audioId);
    }

    print(timerAudio);
    await _recorder?.stopRecorder();
  }

  Future record() async {
    if(isAuth()){
      await _recorder!.startRecorder(toFile: 'audio.mp4');
      if (kDebugMode) {
        print('ПИШЕМ');
      }
    } else {
      await _recorder!.startRecorder(toFile: '${await _getNameAudioCounter()}.mp4');
      if (kDebugMode) {
        print('ПИШЕМ');
      }
    }

  }

  Future<String> _uploadAudio(File recorderFile) async {
    final ref = _storage.ref().child('audio/${await _getNameAudioCounter()}.mp3');
    final uploadTask = ref.putFile(recorderFile, SettableMetadata(contentType: 'audio/mp3'));
    final snapshot = await uploadTask.whenComplete(() {});
    final urlFirestore = await snapshot.ref.getDownloadURL();
    return urlFirestore;
  }

  Future<void> _uploadFirestore(String audioPath, String audioId) async {
    final audioModel = AudioModel(
      id: audioId,
      path: audioPath,
      durationOfAudio: timerAudio,
      titleOfAudio: await _getNameAudioCounter(),
      removedStatus: false,
      timeOfAudio: getTimeAudio(),
      deleteTime: '',
      recordDurationSeconds: recordDurationSeconds!,
    );

    final audioModels = audioModel.toJson();
    final CollectionReference audioList = _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('audioList');
    await audioList.doc(audioId).set(audioModels);
  }

  // final CollectionReference<Map<String, dynamic>> audioList = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('audioList');

  Future<String> _getNameAudioCounter() async {
    final CollectionReference<Map<String, dynamic>> audioList = FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    final query = await audioList.count().get();
    if (kDebugMode) {
      print('Name Audio in FireStore: Аудиозапись${query.count}.mp3');
    }
    return 'Аудиозапись ${query.count}';
  }

  String getTimeAudio() {
    String time = timerAudio;
    List<String> timetoList = time.split(':');
    final minutes = timetoList[0];
    final sec = timetoList[1];
    int intMinutes = int.parse(minutes);
    final int intSec = int.parse(sec);
    if (intMinutes == 0) {
      return time = '$intSec секунд';
    }
    return time = '$intMinutes минут';
  }
}