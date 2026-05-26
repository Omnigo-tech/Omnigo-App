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
  final String phone;

  SendOtpEvent(this.phone,this.userId);
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;

  VerifyOtpEvent(this.phone, this.otp);
}

class ForgotPasswordEvent extends AuthEvent {
  final String emailOrPhone;
  ForgotPasswordEvent(this.emailOrPhone);
}

class ResetPasswordEvent extends AuthEvent {
  final String emailOrPhone;
  final String otp;
  final String newPassword;
  ResetPasswordEvent(this.emailOrPhone, this.otp, this.newPassword);
}

class LogoutEvent extends AuthEvent {}