import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:memory_box/models/audio_model.dart';

class AudiolistRepository {
  List<AudioModel> listDeletedAudio = [];
  List<AudioModel> listNotDeletedAudio = [];

  Future pathAudio(String id) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    final path =
        await collection.doc(id).get().then((value) => value.data()!['path']);
    return path;
  }

  Future nameAudio(String id) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    final path = await collection
        .doc(id)
        .get()
        .then((value) => value.data()!['titleOfAudio'
            '']);
    return path;
  }

  Future<void> deleteAudioId(audioId) async {
    final int durationAudio = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .doc(audioId)
        .get()
        .then((value) => value.data()!['recordDurationSeconds']);

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('collectionList')
        .where('idAudioModels', arrayContains: audioId)
        .get();
    for (var element in snapshot.docs) {
      await element.reference.update({
        'idAudioModels': FieldValue.arrayRemove([audioId]),
        'allTimeAudioCollection': FieldValue.increment(-durationAudio),
      });
    }
  }

  Future deleteAudio(String uuid) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    await collection.doc(uuid).delete();
  }

  Future deleteInNewFolder(String uuid) async {
    final dateTimeNow = DateTime.now();
    final dateFormat = DateFormat('dd.MM.yy');
    final dateDeletedNow = dateFormat.format(dateTimeNow);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .doc(uuid)
        .update({
      'removedStatus': true,
      'deleteTime': dateDeletedNow,
    });
  }

  Future getNotDeletedList() async {
    final sort = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .where('removedStatus', isEqualTo: false)
        .get()
        .then((value) => value.docs);
    listNotDeletedAudio =
        sort.map((e) => AudioModel.fromJson(e.data())).toList();
    return listNotDeletedAudio;
  }

  Future getDeletedList() async {
    final sort = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList')
        .where('removedStatus', isEqualTo: true)
        .get()
        .then((value) => value.docs);
    listDeletedAudio = sort.map((e) => AudioModel.fromJson(e.data())).toList();
    return listDeletedAudio;
  }

  Future deleteToIndex(index) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    await collection.doc(listDeletedAudio[index!].id).delete();
  }

  Future getListIdToIndex(index) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    final id = collection.doc(listDeletedAudio[index!].id).get().toString();
    return id;
  }

  Future restoreToIndex(index) async {
    final collection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('audioList');
    await collection.doc(listDeletedAudio[index!].id).update({
      'removedStatus': false,
    });
  }
}
