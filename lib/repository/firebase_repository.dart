import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memory_box/models/audio_model.dart';

Future<List<AudioModel>> getListAudio() async {
  final sort = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('audioList')
      .orderBy('titleOfAudio', descending: false)
      .get();

  final listAudio =
      sort.docs.map((e) => AudioModel.fromJson(e.data())).toList();
  return listAudio;
}

Future<String> renameAudio(String uuid, String renameAudio) async {
  final collection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('audioList');
  await collection.doc(uuid).update({'titleOfAudio': renameAudio});
  return renameAudio;
}

Future<String> renameAudioAll(String uuid, String renameAudio) async {
  final collection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('audioList');
  await collection.doc(uuid).update({'titleOfAudio': renameAudio});
  return renameAudio;
}

Future deleteToIndex(index, listDeletedAudio) async {
  final collection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('audioList');
  await collection.doc(listDeletedAudio[index].id).delete();
  return deleteToIndex;
}
