import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/repository/auth_repository.dart';
import 'package:memory_box/utils/helpers.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final String verifyId;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String? pathToAvatar;
  String? userName;

  Future pickImage() async {
    final picker = ImagePicker();
    File imageFile;
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

  AuthBloc() : super(AuthState()) {
    on<AuthPhoneEvent>((event, emit) async {
      await _auth.verifyPhoneNumber(
        verificationCompleted: (credential) async {
          await _auth
              .signInWithCredential(credential)
              .then((value) => log('u log in'));
        },
        verificationFailed: (exception) => log('${exception.message}'),
        codeSent: (verificationId, resendToken) => verifyId = verificationId,
        codeAutoRetrievalTimeout: (verificationId) {},
        phoneNumber: '+${event.phoneNumber}',
      );
      emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        status: AuthStatus.sms,
      ));
    });

    on<AuthSmsEvent>((event, emit) async {
      final credential = PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: event.smsCode,
      );
      if (_auth.currentUser == null) {
        await _auth.signInWithCredential(credential);
      } else {
        await _auth.currentUser?.updatePhoneNumber(credential);
      }
      emit(state.copyWith(
        status: AuthStatus.verified,
      ));
    });
    on<GetUserNameEvent>((event, emit) async {
      emit(state.copyWith(userName: event.userName));
    });
    on<UserAvatarEvent>((event, emit) async {
      final pathToAvatar = await pickImage();
      emit(state.copyWith(pathToAvatar: pathToAvatar));
    });
    on<UserInfoSaveEvent>((event, emit) async {
      if (state.userName != null) {
        await AuthRepo.instance.users?.updateDisplayName(state.userName);
      } else {
        await AuthRepo.instance.users?.updatePhotoURL(state.pathToAvatar);
      }
    });
    on<UpdatePhoneEvent>((event, emit) async {});
  }
}
