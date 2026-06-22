import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/core/enums/otp_purpose.dart';
import 'package:grocery_app/data/models/user_model.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/helper/extension/otp_purpose_extension.dart';
import '../../../core/helper/utils/phone_formatter.dart';
import '../../../core/network/api_service.dart';
import '../../models/google_login_response_model.dart';
import '../local/auth_local_data_source.dart';

class AuthRepository {
  final ApiService apiService;
  final AuthLocalDataSource localDataSource;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthRepository(this.apiService,this.localDataSource);



  Future<GoogleLoginResponse> loginWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: "356810750168-mats3inacun39petth3inc4masr1v4p6.apps.googleusercontent.com",
      );

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("Could not retrieve Google ID Token");
      }

      final body = {
        "idToken": idToken,
      };

      return await apiService.googleLogin(body);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final body = {"accessToken": accessToken.tokenString};
        return await apiService.facebookLogin(body);
      } else if (result.status == LoginStatus.cancelled) {
        throw Exception("Facebook Sign-In cancelled by user");
      } else {
        throw Exception(result.message ?? "Facebook Sign-In failed");
      }
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final body = {
        "name": name,
        "email": email,
        "password": password,
      };

      return await apiService.signup(body);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = {"email": email, "password": password};
      return await apiService.login(data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }


  Future<dynamic> sendOtp({
    required String userId,
    required String value,
    required OtpType type,
    required OtpPurpose purpose,
  }) async {
    try {
      final String formattedValue = value.trim();

      final data = {
        "userId": userId,
        "type": type.name,
        "value": formattedValue,
        "purpose": purpose.apiValue,
      };

      return await apiService.sendOtp(data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<dynamic> verifyOtp({
    required String userId,
    required String value,
    required String otp,
    required OtpType type,
    required OtpPurpose purpose,
  }) async {
    try {
      final data = {
        "userId": userId,
        "type": type.name,
        "value": value,
        "purpose": purpose.apiValue,
        "otp": otp,
      };
      return await apiService.verifyOtp(data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<dynamic> verifyForgotPasswordOtp({
    required String userId,
    required String value,
    required String otp,
    required OtpType type,
    required OtpPurpose purpose,
  }) async {
    try {
      final data = {
        "userId": userId,
        "type": type.name,
        "value": value,
        "purpose": purpose.apiValue,
        "otp": otp,
      };

      return await apiService.verifyOtp(data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<dynamic> forgotPassword(String email) async {
    try {
      final data = {"email": email};

      return await apiService.forgotPassword(data);

    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }


  Future<dynamic> resetPassword(  String userId, String newPassword) async {
    final data = {
      "userId": userId,
      "newPassword": newPassword
    };
    return await apiService.resetPassword(data);
  }
}
