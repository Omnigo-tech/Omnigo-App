import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grocery_app/data/models/user_model.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/helper/utils/phone_formatter.dart';
import '../../../core/network/api_service.dart';

class AuthRepository {
  final ApiService apiService;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthRepository(this.apiService);



  Future<UserModel> loginWithGoogle() async {
    try {

      // Initialize Google Sign In
      await _googleSignIn.initialize(
        serverClientId: "407408718192.apps.googleusercontent.com",
      );

      // Trigger sign in
      final GoogleSignInAccount googleUser =
      await _googleSignIn.authenticate();

      // Get auth details
      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("Could not retrieve Google ID Token");
      }

      // Send to backend
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

  // FACEBOOK LOGIN LOGIC
  Future<UserModel> loginWithFacebook() async {
    try {
      // 1. Facebook Sign-In flow start karein
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // 2. Backend API ko access token bhein
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

  Future<UserModel> login({required String email, required String password}) async {
    try {
      final data = {
        "email": email,
        "password": password,
      };
      return await apiService.login(data);
    }

    on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }


  Future<dynamic> sendOtp({
    required String userId,
    required String phone,
  }) async {
    try{
      String formattedPhone = phone.trim();
      if (!formattedPhone.startsWith('0')) {
        formattedPhone = '0$formattedPhone';
      }
    final data = {
      "userId": userId,
      "phone": formattedPhone,
    };
    return await apiService.sendOtp(data);
  } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
    }

  Future<dynamic> verifyOtp({required String phone, required String otp}) async {
    try{
      final data = {
        "phone": PhoneFormatter.format(phone),
        "otp": otp,
      };
      return await apiService.verifyOtp(data);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }

  }

  Future<dynamic> forgotPassword(String emailOrPhone) async {
    final data = {"emailOrPhone": emailOrPhone};
    return await apiService.forgotPassword(data);
  }

  Future<dynamic> resetPassword(String emailOrPhone, String otp, String newPassword) async {
    final data = {
      "emailOrPhone": emailOrPhone,
      "otp": otp,
      "password": newPassword,
    };
    return await apiService.resetPassword(data);
  }
}
