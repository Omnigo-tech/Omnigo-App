import 'package:grocery_app/data/models/address.dart';

abstract class AddressEvent {}

class LoadAddresses extends AddressEvent {}

class SelectAddressEvent extends AddressEvent {
  final AddressModel address;

  SelectAddressEvent(this.address);
}
