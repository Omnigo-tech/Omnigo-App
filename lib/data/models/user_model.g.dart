// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  message: json['message'] as String,
  token: json['token'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'message': instance.message,
  'token': instance.token,
  'user': instance.user,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  role: json['role'] as String,
  isPhoneVerified: json['isPhoneVerified'] as bool,
  isEmailVerified: json['isEmailVerified'] as bool,
  name: json['name'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'role': instance.role,
  'isPhoneVerified': instance.isPhoneVerified,
  'isEmailVerified': instance.isEmailVerified,
  'name': instance.name,
  'email': instance.email,
};
