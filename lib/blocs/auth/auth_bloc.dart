import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memory_box/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final String verifyId;
  final AuthRepository _authRepository = AuthRepository();

  AuthBloc() : super(AuthState()) {
    on<AuthPhoneEvent>((event, emit) async {
      await _authRepository.auth.verifyPhoneNumber(
        verificationCompleted: (credential) async {
          await _authRepository.auth
              .signInWithCredential(credential)
              .then((value) => log('LogIn'));
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
      if (_authRepository.auth.currentUser == null) {
        await _authRepository.auth.signInWithCredential(credential);
      } else {
        await _authRepository.auth.currentUser?.updatePhoneNumber(credential);
      }
      emit(state.copyWith(
        status: AuthStatus.verified,
      ));
    });
    on<GetUserNameEvent>((event, emit) async {
      emit(state.copyWith(userName: event.userName));
    });
    on<UserAvatarEvent>((event, emit) async {
      final pathToAvatar = await _authRepository.pickImage();
      emit(state.copyWith(pathToAvatar: pathToAvatar));
    });
    on<UserInfoSaveEvent>((event, emit) async {
      if (state.userName != null) {
        await _authRepository.users?.updateDisplayName(state.userName);
      } else {
        await _authRepository.users?.updatePhotoURL(state.pathToAvatar);
      }
    });
    on<UpdatePhoneEvent>((event, emit) async {});
  }
}
