import 'package:flutter_bloc/flutter_bloc.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(const PaymentState()) {

    on<UpdateHolder>((event, emit) {
      emit(state.copyWith(holder: event.value));
    });

    on<UpdateCardNumber>((event, emit) {
      emit(state.copyWith(cardNumber: event.value));
    });

    on<UpdatePhoneNumber>((event, emit) {
      emit(state.copyWith(phoneNumber: event.value));
    });

    on<UpdateExpiry>((event, emit) {
      emit(state.copyWith(expiry: event.value));
    });

    on<UpdateCvv>((event, emit) {
      emit(state.copyWith(cvv: event.value));
    });

    on<ToggleCvv>((event, emit) {
      emit(state.copyWith(showCvv: !state.showCvv));
    });

    on<ChangeCardIndex>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });

    on<ChangeWalletIndex>((event, emit) {
      emit(state.copyWith(walletIndex: event.index));
    });

    on<ChangeBankIndex>((event, emit) {
      emit(state.copyWith(bankIndex: event.index));
    });
  }
}