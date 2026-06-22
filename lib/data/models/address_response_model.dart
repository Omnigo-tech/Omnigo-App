
class AddressResponseModel {
  final bool success;
  final String? message;
  final UserData? user;
  final List<ServerAddressModel> addresses;

  AddressResponseModel({
    required this.success,
    this.message,
    this.user,
    required this.addresses,
  });

  factory AddressResponseModel.fromJson(Map<String, dynamic> json) {
    return AddressResponseModel(
      success: json['success'] ?? false,
      message: json['message'],
      user: json['user'] != null
          ? UserData.fromJson(json['user'])
          : null,
      addresses: (json['addresses'] as List?)
          ?.map((e) => ServerAddressModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class ServerAddressModel {
  final String id;
  final String phone;
  final String address;
  final String city;
  final String zipCode;
  final String country;
  final bool isDefault;

  ServerAddressModel({
    required this.id,
    required this.phone,
    required this.address,
    required this.city,
    required this.zipCode,
    required this.country,
    required this.isDefault,
  });

  factory ServerAddressModel.fromJson(Map<String, dynamic> json) {
    return ServerAddressModel(
      id: json['_id'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      zipCode: json['zipCode'] ?? '',
      country: json['country'] ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }
}


class UserData {
  final String id;
  final String name;
  final String email;

  UserData({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}