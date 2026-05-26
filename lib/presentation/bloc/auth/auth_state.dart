abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;
  final dynamic data;

  AuthSuccess(this.message, this.data);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

class OtpSentState extends AuthState {
  final String message;

  OtpSentState(this.message);
}
class OtpVerifiedState extends AuthState {
  final String message;
  final dynamic data;

  OtpVerifiedState(this.message, this.data);
}