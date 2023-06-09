// https://github.com/firebase/firebase-ios-sdk

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/models/collection_model.dart';
import 'package:memory_box/pages/splash_page/splash_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_text_styles.dart';
import 'package:uuid/uuid.dart';

bool isAuth() {
  return FirebaseAuth.instance.currentUser == null;
}

isLogOut() async {
  FirebaseAuth.instance.currentUser?.delete();
  FirebaseAuth.instance.signOut();
}

isLogOutTwo() async {
  return FirebaseAuth.instance.signOut();
}

bool checkAvatar() {
  return FirebaseAuth.instance.currentUser?.photoURL == null;
}

bool checkName() {
  return FirebaseAuth.instance.currentUser?.displayName == null;
}

Future<List<AudioModel>> getListAudioHelper() async {
  final sort = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('audioList')
      .orderBy('titleOfAudio', descending: false);
  final QuerySnapshot querySnapshot = await sort.get();
  final listAudio = querySnapshot.docs
      .map((e) => AudioModel.fromJson(e.data() as Map<String, dynamic>))
      .toList();
  return listAudio;
}

String allAudioTime(totalDurationFromAudioModel) {
  final seconds = totalDurationFromAudioModel.fold(0, (value, element) {
    final singleTime = element.split(':');
    return value +
        (int.parse(singleTime.first) * 60) +
        int.parse(singleTime.last);
  });
  final int h = seconds ~/ 3600, m = ((seconds - h * 3600)) ~/ 60;
  final hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

  final minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();
  if (h == 0) {
    return '$hourLeft:$minuteLeft минут';
  } else {
    return '$hourLeft:$minuteLeft часов';
  }
}

class TimerFormat {
  String format(Duration duration, {bool recorder = false}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitHours = twoDigits(duration.inHours.remainder(60));
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (recorder == true || duration.inHours > 0) twoDigitHours,
      twoDigitMinutes,
      twoDigitSeconds,
    ].join(':');
  }
}

String totalDurationSeconds(totalDuradion) {
  final int h = totalDuradion ~/ 3600, m = ((totalDuradion - h * 3600)) ~/ 60;
  final hourLeft = h.toString().length < 2 ? "0$h" : h.toString();

  final minuteLeft = m.toString().length < 2 ? "0$m" : m.toString();
  if (h == 0) {
    return '$hourLeft:$minuteLeft минут';
  } else {
    return '$hourLeft:$minuteLeft часов';
  }
}

String getId() {
  const uuid = Uuid();
  return uuid.v4();
}

String dateNow() {
  final dateTimeNow = DateTime.now();
  final dateFormat = DateFormat('dd.MM.yy');
  final dateNow = dateFormat.format(dateTimeNow);
  return dateNow;
}

Future<List<CollectionAudioModel>> getListCollectionHelper() async {
  final sort = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('collectionList');
  final QuerySnapshot querySnapshot = await sort.get();
  final collectionList = querySnapshot.docs
      .map((e) =>
          CollectionAudioModel.fromJson(e.data() as Map<String, dynamic>))
      .toList();
  return collectionList;
}

String generateRandomString() {
  var random = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final randomString =
      List.generate(5, (index) => _chars[random.nextInt(_chars.length)]).join();
  return randomString;
}

class AudioId {
  static String? audioId;
  static String? collectionId;
  static int? audioInSeconds;
  static List audioIdList = [];
}

Future<void> showDialogAcc(context) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          content: SizedBox(
            width: 320,
            height: 248,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'К сожалению, вы не зарегистрированы',
                  style: AppTextStyles.black20,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  'Регистрация привяжет твои сказки  к облаку, \nпосле чего они всегда будут с тобой',
                  style: AppTextStyles.grey14,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamedAndRemoveUntil(
                          SplashScreen.routeName,
                          (_) => false,
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 41,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(51),
                          ),
                          color: AppColors.purple,
                        ),
                        child: Center(
                          child: Text(
                            'Регистрация',
                            style: AppTextStyles.white16,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 82,
                        height: 41,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(51),
                          ),
                          border:
                              Border.all(color: AppColors.purple, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            'Нет',
                            style: AppTextStyles.purple16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      });
}
