import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  AuthRepo._() {
    init();
  }
  static User? user;

  static final AuthRepo instance = AuthRepo._();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? users;

  void init() {
    users = _auth.currentUser;
    log('AppInformation: '
        'name ${users?.photoURL}'
        'name ${users?.displayName}'
        'Phone: ${users?.phoneNumber} '
        'UID: ${users?.uid} ');
  }
}
