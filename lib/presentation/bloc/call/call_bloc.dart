import 'package:flutter_bloc/flutter_bloc.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc() : super(CallState(status: CallStatus.idle)) {

    on<StartCall>((event, emit) {
      emit(CallState(status: CallStatus.ringing, userName: event.userName));
    });

    on<DeclineCall>((event, emit) {
      emit(CallState(status: CallStatus.ended, userName: state.userName));
    });
  }
}