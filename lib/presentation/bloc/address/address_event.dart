import 'package:grocery_app/data/models/address.dart';

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
  final int index;
  DeleteAddressEvent(this.index);
}

class UpdateAddressEvent extends AddressEvent {
  final int index;
  final AddressModel address;

  UpdateAddressEvent(this.index, this.address);
}
