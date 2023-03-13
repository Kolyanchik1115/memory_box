part of 'auth_bloc.dart';

enum AuthStatus { sms, phone, verified }

class AuthState {
  final AuthStatus status;
  final String? verificationIdReceived;
  final String? phoneNumber;
  final String? userName;
  final String pathToAvatar;

  AuthState({
    this.status = AuthStatus.phone,
    this.verificationIdReceived,
    this.phoneNumber,
    this.userName,
    this.pathToAvatar = '',
  });
  AuthState copyWith({
    AuthStatus? status,
    String? verificationIdReceived,
    String? phoneNumber,
    String? userName,
    String? pathToAvatar,
  }) {
    return AuthState(
      status: status ?? this.status,
      verificationIdReceived:
          verificationIdReceived ?? this.verificationIdReceived,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userName: userName ?? this.userName,
      pathToAvatar: pathToAvatar ?? this.pathToAvatar,
    );
  }
}
