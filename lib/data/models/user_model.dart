import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final bool success;
  final String message;
  final String token;
  final User user;

  UserModel({
    required this.success,
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
  @JsonKey(name: 'id')
  final String id;
  final String role;
  final bool isPhoneVerified;
  final bool isEmailVerified;
  final String name;
  final String email;
  final String? phone;
  final String? lastLogin; // ✨ Isko nullable (?) kiya kyunki Google login mein yeh null ho sakta hai
  final bool hasLocation;
  final UserLocation? location;

  User({
    required this.id,
    required this.role,
    required this.isPhoneVerified,
    required this.isEmailVerified,
    required this.name,
    required this.email,
    this.phone,
    this.lastLogin, // ✨ required hata diya
    required this.hasLocation,
    this.location,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class UserLocation {
  final String? id;
  final String? type;
  final Coordinates? coordinates;
  final String? zone;
  final String? area;
  final String? address;
  final bool? isEnabled;
  UserLocation({
    this.id,
    this.type,
    this.coordinates,
    this.zone,    // ✨ required hata diya
    this.area,    // ✨ required hata diya
    this.address, // ✨ required hata diya
    this.isEnabled,
  });

  factory UserLocation.fromJson(Map<String, dynamic> json) =>
      _$UserLocationFromJson(json);

  Map<String, dynamic> toJson() => _$UserLocationToJson(this);
}

@JsonSerializable()
class Coordinates {
  final double? lat;
  final double? lng;

  Coordinates({
    this.lat,
    this.lng,
  });

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}