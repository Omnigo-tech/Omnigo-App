import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/otp_purpose.dart';
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
        await repository.localDataSource.saveToken(
          res.token,
        );

        await repository.localDataSource.saveUserId(
          res.user.id,
        );
        if (res.user.hasLocation == true && res.user.location != null) {
          await repository.localDataSource.saveUserLocation(res.user.location!.toJson());
        }
        print("====== 🔐 AUTH LOCAL STORAGE DEBUG ======");
        print("Stored Token: ${repository.localDataSource.getToken()}");
        print("Stored User ID: ${repository.localDataSource.getUserId()}");
        print("Has Location Flag Saved: ${repository.localDataSource.hasLocationSaved()}");
        final savedLocationMap = repository.localDataSource.getUserLocation();
        if (savedLocationMap != null) {
          // jsonEncode se print bilkul proper structured JSON format mein dikhega terminal par
          print("Stored Location Data: ${jsonEncode(savedLocationMap)}");
        } else {
          print("Stored Location Data: NULL (No location configured for this user yet)");
        }
        print("=========================================");
        // ================== ✨ DEBUG PRINTS END ====================
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
          value: event.value,
          type: event.type,
          purpose: event.purpose,
        );

        emit(
          OtpSentState(
            res["message"],
            res["userId"],
          ),
        );

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

        dynamic res;

        if (event.purpose == OtpPurpose.forgotPassword) {

          res = await repository.verifyForgotPasswordOtp(
            userId: event.userId,
            value: event.value,
            otp: event.otp,
            type: event.type,
            purpose: event.purpose,
          );

        } else {

           res = await repository.verifyOtp(
            userId: event.userId,
            value: event.value,
            otp: event.otp,
            type: event.type,
            purpose: event.purpose,
          );
        }

        emit(OtpVerifiedState("OTP Verified", res));

      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    /// FORGOT PASSWORD
    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await repository.forgotPassword(event.emailOrPhone);
        emit(
          OtpSentState(
            res["message"],
            res["userId"],
          ),
        );
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    /// RESET PASSWORD
    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await repository.resetPassword(
          event.userId,
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
        await repository.localDataSource.saveToken(res.token);
        await repository.localDataSource.saveUserId(res.user.id);

        if (res.user.hasLocation == true && res.user.location != null) {
          await repository.localDataSource.saveUserLocation(res.user.location!.toJson());
        }
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
        await repository.localDataSource.saveToken(res.token);
        await repository.localDataSource.saveUserId(res.user.id);

        if (res.user.hasLocation == true && res.user.location != null) {
          await repository.localDataSource.saveUserLocation(res.user.location!.toJson());
        }
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
