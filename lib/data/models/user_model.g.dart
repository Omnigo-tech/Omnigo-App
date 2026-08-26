// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  success: json['success'] as bool,
  message: json['message'] as String,
  token: json['token'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'success': instance.success,
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
  phone: json['phone'] as String?,
  lastLogin: json['lastLogin'] as String?,
  hasLocation: json['hasLocation'] as bool,
  location: json['location'] == null
      ? null
      : UserLocation.fromJson(json['location'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'role': instance.role,
  'isPhoneVerified': instance.isPhoneVerified,
  'isEmailVerified': instance.isEmailVerified,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'lastLogin': instance.lastLogin,
  'hasLocation': instance.hasLocation,
  'location': instance.location,
};

UserLocation _$UserLocationFromJson(Map<String, dynamic> json) => UserLocation(
  id: json['id'] as String?,
  type: json['type'] as String?,
  coordinates: json['coordinates'] == null
      ? null
      : Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
  zone: json['zone'] as String?,
  area: json['area'] as String?,
  address: json['address'] as String?,
  isEnabled: json['isEnabled'] as bool?,
);

Map<String, dynamic> _$UserLocationToJson(UserLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'coordinates': instance.coordinates,
      'zone': instance.zone,
      'area': instance.area,
      'address': instance.address,
      'isEnabled': instance.isEnabled,
    };

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};
