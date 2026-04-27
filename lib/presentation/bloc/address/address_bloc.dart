import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/data/models/address.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressBloc() : super(AddressState()) {
    on<LoadAddresses>((event, emit) {
      final list = [
        AddressModel(
          locationname: "Home",
          username: "John Doe",
          phone: "0300-1234567",
          address: "Cendana Street 1, Jakarta, Pakistan",
        ),
        AddressModel(
          locationname: "Office",
          username: "John Doe",
          phone: "0301-7654321",
          address: "Kemang, Sudirman Central Bussiness District, Indonesia",
        ),
      ];

      emit(
        state.copyWith(
          addresses: list,
          selectedAddress: list.first, // default
        ),
      );
    });

    on<SelectAddressEvent>((event, emit) {
      emit(state.copyWith(selectedAddress: event.address));
    });
  }
}
