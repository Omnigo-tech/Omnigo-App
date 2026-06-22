import 'package:grocery_app/data/models/address.dart';
import 'package:grocery_app/data/models/address_response_model.dart';

abstract class AddressEvent {}

class LoadAddresses extends AddressEvent {}

class SelectAddressEvent extends AddressEvent {
  final AddressModel address;

  SelectAddressEvent(this.address);
}

class AddAddressEvent extends AddressEvent {
  final AddressModel address;
  final bool save;

  AddAddressEvent(this.address, this.save);
}

class DeleteAddressEvent extends AddressEvent {
  final String id;
  DeleteAddressEvent(this.id);
}

class UpdateAddressEvent extends AddressEvent {
  final AddressModel address;
  UpdateAddressEvent(this.address);
}
