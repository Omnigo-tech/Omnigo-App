class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final bool isPhoneVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.isPhoneVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'], // nullable
      isPhoneVerified: json['isPhoneVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'isPhoneVerified': isPhoneVerified,
    };
  }
}
