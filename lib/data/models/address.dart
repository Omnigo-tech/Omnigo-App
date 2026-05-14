class AddressModel {
  final String locationname;
  final String username;
  final String phone;
  final String address;
  final int? zipcode;
  final String? city;
  final bool? isSave;

  AddressModel({
    required this.locationname,
    required this.username,
    required this.phone,
    required this.address,
     this.zipcode,
     this.city,
     this.isSave,
  });

  operator +(int other) {}
}
