import 'package:grocery_app/data/models/address.dart';

class AddressState {
  final List<AddressModel> addresses;
  final AddressModel? selectedAddress;

  AddressState({this.addresses = const [], this.selectedAddress});

  AddressState copyWith({
    List<AddressModel>? addresses,
    AddressModel? selectedAddress,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }
}
