import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String message;
  final String token;
  final User user;

  UserModel({
    required this.message,
    required this.token,
    required this.user,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class User {
  final String id;
  final String role;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final String name;
  final String email;

  User({
    required this.id,
    required this.role,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}