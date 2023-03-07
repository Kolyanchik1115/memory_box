import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final String verifyId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
  }
}
