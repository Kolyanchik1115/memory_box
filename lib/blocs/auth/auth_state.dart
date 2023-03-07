part of 'auth_bloc.dart';

enum AuthStatus { sms, phone, verified }

class AuthState {
  final AuthStatus status;
  final String? verificationIdReceived;
  final String? phoneNumber;

  AuthState({
    this.status = AuthStatus.phone,
    this.verificationIdReceived,
    this.phoneNumber,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? verificationIdReceived,
    String? phoneNumber,
  }) {
    return AuthState(
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationIdReceived:
          verificationIdReceived ?? this.verificationIdReceived,
    );
  }
}
