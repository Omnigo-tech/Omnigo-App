import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/presentation/bloc/payment/payment_event.dart';
import 'package:grocery_app/presentation/bloc/payment/payment_state.dart';

class CreditCardBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentState()) {

    on<UpdateHolder>((event, emit) {
      emit(state.copyWith(holder: event.value));
    });

    on<UpdateNumber>((event, emit) {
      emit(state.copyWith(number: event.value));
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
  }
}