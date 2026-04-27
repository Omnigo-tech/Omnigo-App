class AddressModel {
  final String locationname;
  final String username;
  final String phone;
  final String address;

  AddressModel({
    required this.locationname,
    required this.username,
    required this.phone,
    required this.address,
  });

  operator +(int other) {}
}
