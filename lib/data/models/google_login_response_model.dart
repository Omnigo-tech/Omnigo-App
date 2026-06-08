import 'package:grocery_app/data/models/user_model.dart';

class GoogleLoginResponse {
  final bool success;
  final String message;
  final String token;
  final User user;

  GoogleLoginResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory GoogleLoginResponse.fromJson(Map<String, dynamic> json) {
    return GoogleLoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: User.fromJson(json['user']),
    );
  }
}