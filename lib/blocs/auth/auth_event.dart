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

class GetUserNameEvent extends AuthEvent {
  final String userName;
  GetUserNameEvent({
    required this.userName,
  });
}

class UpdatePhoneEvent extends AuthEvent {
  final String phoneNumber;
  UpdatePhoneEvent({required this.phoneNumber});
}

class UserAvatarEvent extends AuthEvent {}

class UserInfoSaveEvent extends AuthEvent {}
