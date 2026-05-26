import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/exceptions.dart';
import '../../../data/datasource/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {

    on<SignupEvent>((event, emit) async {

      emit(AuthLoading());

      try {

        final response = await repository.signup(
          name: event.name,
          email: event.email,
          password: event.password,
        );

        emit(AuthSuccess(response.message,response));

      } on ServerException catch (e) {

        emit(AuthFailure(e.message));

      } on NetworkException catch (e) {

        emit(AuthFailure(e.message));

      } catch (e) {

        emit(AuthFailure("Unexpected error"));
      }
    });

    /// LOGIN
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final res = await repository.login(
          email: event.email,
          password: event.password,
        );

        emit(AuthSuccess(res.message,res));

      } on ServerException catch (e) {

        emit(AuthFailure(e.message));

      } on NetworkException catch (e) {

        emit(AuthFailure(e.message));

      } catch (e) {

        emit(AuthFailure("Unexpected error"));
      }
    });

    /// SEND OTP
    on<SendOtpEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final res = await repository.sendOtp(
          userId: event.userId,
          phone: event.phone,
        );

        emit(OtpSentState(res["message"]));
      } on NetworkException catch (e) {

        emit(AuthFailure(e.message));

      } catch (e) {

        emit(AuthFailure("Unexpected error"));
      }
    });

    /// VERIFY OTP
    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final res = await repository.verifyOtp(
          phone: event.phone,
          otp: event.otp,
        );

        emit(OtpVerifiedState("Phone Verified", res));
      } on NetworkException catch (e) {

        emit(AuthFailure(e.message));

      } catch (e) {
        emit(AuthFailure("Unexpected error"));
      }
    });

    /// FORGOT PASSWORD
    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await repository.forgotPassword(event.emailOrPhone);
        emit(OtpSentState(res["message"] ?? "OTP sent successfully"));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    /// RESET PASSWORD
    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await repository.resetPassword(
          event.emailOrPhone,
          event.otp,
          event.newPassword,
        );
        emit(AuthSuccess(res["message"] ?? "Password updated successfully", res));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    on<GoogleLoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await repository.loginWithGoogle();
        emit(AuthSuccess(res.message, res));
      } on ServerException catch (e) {
        emit(AuthFailure(e.message));
      } on NetworkException catch (e) {
        emit(AuthFailure(e.message));
      } catch (e) {
        emit(AuthFailure(e.toString().replaceAll("Exception: ", "")));
      }
    });

    /// FACEBOOK LOGIN
    on<FacebookLoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await repository.loginWithFacebook();
        emit(AuthSuccess(res.message , res));
      } on ServerException catch (e) {
        emit(AuthFailure(e.message));
      } on NetworkException catch (e) {
        emit(AuthFailure(e.message));
      } catch (e) {
        emit(AuthFailure(e.toString().replaceAll("Exception: ", "")));
      }
    });
  }
}
