import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/utils/helpers.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordRepository {
  late final String timerAudio;

  bool _isRecorderReady = false;
  int? recordDurationSeconds;

  FlutterSoundRecorder? recorder;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getNameAudioCounter() async {
    final CollectionReference<Map<String, dynamic>> audioList =
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('audioList');
    final query = await audioList.count().get();
    return 'Аудиозапись ${query.count}';
  }

  Future<void> uploadFirestore(String audioPath, String audioId) async {
    final audioModel = AudioModel(
      id: audioId,
      path: audioPath,
      durationOfAudio: timerAudio,
      titleOfAudio: await getNameAudioCounter(),
      removedStatus: false,
      timeOfAudio: getTimeAudio(),
      deleteTime: '',
      recordDurationSeconds: recordDurationSeconds!,
    );

    final audioModels = audioModel.toJson();
    final CollectionReference audioList = _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    await audioList.doc(audioId).set(audioModels);
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

  Future stop(String audioId) async {
    if (!_isRecorderReady) return;
    final path = await recorder?.stopRecorder();
    final audioFile = File(path!);
    if (isAuth()) {
    } else {
      final audioPath = await _uploadAudio(audioFile);
      await uploadFirestore(audioPath, audioId);
    }
    await recorder?.stopRecorder();
  }

  Future record() async {
    if (isAuth()) {
      await recorder!.startRecorder(toFile: 'audio.mp4');
    } else {
      await recorder!
          .startRecorder(toFile: '${await getNameAudioCounter()}.mp4');
    }
  }

  Future<String> _uploadAudio(File recorderFile) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    final ref = storage.ref().child('audio/${await getNameAudioCounter()}.mp3');
    final uploadTask =
        ref.putFile(recorderFile, SettableMetadata(contentType: 'audio/mp3'));
    final snapshot = await uploadTask.whenComplete(() {});
    final urlFirestore = await snapshot.ref.getDownloadURL();
    return urlFirestore;
  }

  Future initRecorder() async {
    recorder = FlutterSoundRecorder();
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }
    await recorder!.openRecorder();

    _isRecorderReady = true;
    recorder!.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  void dispose() {
    if (!_isRecorderReady) return;
    recorder!.closeRecorder();
    recorder = null;
    _isRecorderReady = false;
  }
}
