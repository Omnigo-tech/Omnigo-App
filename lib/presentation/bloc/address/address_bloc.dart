import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/data/models/address.dart';
import '../../../data/datasource/repositories/address_repository.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository addressRepository;

  AddressBloc(this.addressRepository) : super(AddressState()) {

    on<LoadAddresses>((event, emit) async {
      try {
        final response = await addressRepository.getAddresses();

        if (response.success) {
          final currentUserName = response.user?.name ?? "User";
          final mappedList = response.addresses.map((srv) {
            return AddressModel(
              id: srv.id,
              locationname: srv.isDefault ? "Default Address" : "Saved Address",
              username: currentUserName,
              phone: srv.phone,
              address: "${srv.address}, ${srv.city}, ${srv.country}",
              zipcode: int.tryParse(srv.zipCode) ?? 0,
              city: srv.city,
              isSave: true,
              country: srv.country,
            );
          }).toList();

          emit(state.copyWith(
            addresses: mappedList,
            selectedAddress: mappedList.isNotEmpty ? mappedList.first : null,
          ));
        }
      } catch (e) {
        print("Load Addresses Error: $e");
      }
    });

    on<SelectAddressEvent>((event, emit) {
      emit(state.copyWith(selectedAddress: event.address));
    });

    on<AddAddressEvent>((event, emit) async {
      try {
        final body = {
          "phone": event.address.phone,
          "address": event.address.address,
          "city": event.address.city ?? '',
          "zipCode": event.address.zipcode.toString(),
          "country": event.address.country,

        };

        final response = await addressRepository.addAddress(body);

        if (response.success) {
          final currentUserName = response.user?.name ?? "User";
          final updatedList = response.addresses.map((srv) {
            return AddressModel(
              id: srv.id,
              locationname: srv.isDefault ? "Default Address" : "Saved Address",
              username: currentUserName,
              phone: srv.phone,
              address: "${srv.address}, ${srv.city}, ${srv.country}",
              zipcode: int.tryParse(srv.zipCode) ?? 0,
              city: srv.city,
              isSave: true,
              country: srv.country,
            );
          }).toList();

          emit(state.copyWith(
            addresses: updatedList,
            selectedAddress: updatedList.isNotEmpty ? updatedList.last : null,
          ));
        }
      } catch (e) {
        print("Add Address Error: $e");
      }
    });

    on<DeleteAddressEvent>((event, emit) async {
      try {
        final String addressId = event.id;
        final response = await addressRepository.deleteAddress(addressId);

        if (response.success) {
          final currentUserName = state.addresses.isNotEmpty
              ? state.addresses.first.username
              : "User";

          final updatedList = response.addresses.map((srv) {
            return AddressModel(
              id: srv.id,
              locationname: srv.isDefault ? "Default Address" : "Saved Address",
              username: currentUserName,
              phone: srv.phone,
              address: "${srv.address}, ${srv.city}, ${srv.country}",
              zipcode: int.tryParse(srv.zipCode) ?? 0,
              city: srv.city,
              isSave: true,
              country: srv.country,
            );
          }).toList();

          emit(state.copyWith(
            addresses: updatedList,
            selectedAddress: updatedList.isNotEmpty ? updatedList.first : null,
          ));
          print("Success Message: ${response.message}");
        }
      } catch (e) {
        print("Delete Address Error: $e");
      }
    });

    on<UpdateAddressEvent>((event, emit) async {
      try {
        final String addressId = event.address.id;

        final body = {
          "phone": event.address.phone,
          "address": event.address.address,
          "city": event.address.city ?? '',
          "zipCode": event.address.zipcode.toString(),
          "country": event.address.country,
        };

        final response = await addressRepository.updateAddress(addressId, body);

        if (response.success) {
          final currentUserName = state.addresses.isNotEmpty
              ? state.addresses.first.username
              : "User";

          final updatedList = response.addresses.map((srv) {
            return AddressModel(
              id: srv.id,
              locationname: srv.isDefault ? "Default Address" : "Saved Address",
              username: currentUserName,
              phone: srv.phone,
              address: "${srv.address}, ${srv.city}, ${srv.country}",
              zipcode: int.tryParse(srv.zipCode) ?? 0,
              city: srv.city,
              isSave: true,
              country: srv.country,
            );
          }).toList();

          // FIXED: Yahan id matching lagayi hai address mapping text string comparison hata kar
          final newlyUpdatedAddress = updatedList.firstWhere(
                (element) => element.id == addressId,
            orElse: () => updatedList.first,
          );

          emit(state.copyWith(
            addresses: updatedList,
            selectedAddress: newlyUpdatedAddress,
          ));

          print("Success Message: ${response.message}");
        }
      } catch (e) {
        print("Update Address Error: $e");
      }
    });
  }
}