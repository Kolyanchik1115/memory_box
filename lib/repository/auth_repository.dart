import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/utils/helpers.dart';

class AuthRepository {
  final User? users = FirebaseAuth.instance.currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future pickImage() async {
    final picker = ImagePicker();
    final File imageFile;
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    imageFile = File(pickedFile!.path);
    final path = await _uploadImage(imageFile);
    return path;
  }

  Future<String> _uploadImage(File image) async {
    final nameImage = generateRandomString();
    final ref = _storage.ref().child(
        'image-${FirebaseAuth.instance.currentUser!.uid}/$nameImage.jpg');
    final uploadTask =
        ref.putFile(image, SettableMetadata(contentType: 'image/jpg'));
    final snapshot = await uploadTask.whenComplete(() {});
    final urlFirestore = await snapshot.ref.getDownloadURL();
    return urlFirestore;
  }

  // void init() {
  //   log('AppInformation: '
  //       'name ${users?.photoURL}'
  //       'name ${users?.displayName}'
  //       'Phone: ${users?.phoneNumber} '
  //       'UID: ${users?.uid} ');
  // }
}
