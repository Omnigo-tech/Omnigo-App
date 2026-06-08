import '../../../core/enums/otp_purpose.dart';

abstract class AuthEvent {}

class SignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignupEvent(this.name, this.email, this.password);
}

class GoogleLoginEvent extends AuthEvent {}
class FacebookLoginEvent extends AuthEvent {}


class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class SendOtpEvent extends AuthEvent {

  final String userId;
  final OtpType type;
  final String value; // phone OR email
  final OtpPurpose purpose;

  SendOtpEvent({
    required this.userId,
    required this.type,
    required this.value,
    required this.purpose,
  });
}

class VerifyOtpEvent extends AuthEvent {
  final String userId;
  final String value; // phone OR email
  final String otp;
  final OtpPurpose purpose;
  final OtpType type;

  VerifyOtpEvent({
    required this.userId,
    required this.value,
    required this.otp,
    required this.purpose,
    required this.type,
  });
}

class ForgotPasswordEvent extends AuthEvent {
  final String emailOrPhone;
  ForgotPasswordEvent(this.emailOrPhone);
}

class ResetPasswordEvent extends AuthEvent {
  final String userId;
  final String newPassword;
  ResetPasswordEvent(this.userId, this.newPassword);
}

class LogoutEvent extends AuthEvent {}