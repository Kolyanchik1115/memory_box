part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class AuthPhoneEvent extends AuthEvent {
  final String phoneNumber;

  AuthPhoneEvent({required this.phoneNumber});
}

class AuthSmsEvent extends AuthEvent {
  final String smsCode;

  AuthSmsEvent({required this.smsCode});
}
