// https://github.com/firebase/firebase-ios-sdk

import 'package:firebase_auth/firebase_auth.dart';

bool isAuth() {
  return FirebaseAuth.instance.currentUser == null;
}