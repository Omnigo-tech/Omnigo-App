class AddressModel {
  final String id;
  final String locationname;
  final String username;
  final String phone;
  final String address;
  final String country;
  final int? zipcode;
  final String? city;
  final bool? isSave;

  AddressModel({
    required this.id,
    required this.locationname,
    required this.username,
    required this.phone,
    required this.address,
    required this.country,
    this.zipcode,
    this.city,
    this.isSave,
  });
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['addressId'] ?? json['_id'] ?? '',
      locationname: json['isDefault'] == true
          ? 'Default Address'
          : 'Saved Address',
      username: json['username'] ?? 'User',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      zipcode: int.tryParse(json['zipCode']?.toString() ?? '0'),
      isSave: true,
    );
  }

  // BLoC mein state update karne ke liye copyWith bahut helpful hai
  AddressModel copyWith({
    String? id,
    String? locationname,
    String? username,
    String? phone,
    String? address,
    String? country,
    int? zipcode,
    String? city,
    bool? isSave,
  }) {
    return AddressModel(
      id: id ?? this.id,
      locationname: locationname ?? this.locationname,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      country: country ?? this.country,
      zipcode: zipcode ?? this.zipcode,
      city: city ?? this.city,
      isSave: isSave ?? this.isSave,
    );
  }
}