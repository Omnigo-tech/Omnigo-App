import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/remote/socket_service.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  final SocketService socketService;
  StreamSubscription? _socketSubscription;

  CallBloc(this.socketService) : super(CallState.initial()) {
    on<StartCall>(_onStartCall);
    on<DeclineCall>(_onDeclineCall);
    on<AcceptCall>(_onAcceptCall);

    // Global background initialization sequence for calls
    _initSocketCallListener();
  }

  void _initSocketCallListener() {
    _socketSubscription = socketService.orderStatusStream.listen((data) {
      if (data['event'] == 'incomingCall') {
        // Handle incoming screen execution downstream
        // Note: targetId yahan callerId ban jayega callback ke liye
      } else if (data['event'] == 'callEnded' || data['event'] == 'callAccepted') {
        if (data['event'] == 'callEnded') {
          add(DeclineCall());
        } else if (data['event'] == 'callAccepted') {
          add(AcceptCall());
        }
      }
    });
  }

  void _onStartCall(StartCall event, Emitter<CallState> emit) {
    emit(state.copyWith(
      status: CallStatus.ringing,
      userName: event.receiverName,
      conversationId: event.conversationId,
      targetId: event.receiverId,
    ));

    // Pipeline message across server sockets
    socketService.emitInitiateCall(
      conversationId: event.conversationId,
      callerId: event.currentUserId,
      receiverId: event.receiverId,
    );
  }

  void _onAcceptCall(AcceptCall event, Emitter<CallState> emit) {
    emit(state.copyWith(status: CallStatus.connected));
  }

  void _onDeclineCall(DeclineCall event, Emitter<CallState> emit) {
    if (state.conversationId != null && state.targetId != null) {
      socketService.emitEndCall(
        conversationId: state.conversationId!,
        targetId: state.targetId!,
        reason: event.isRejectedReason ? "rejected" : "ended",
      );
    }
    emit(state.copyWith(status: CallStatus.ended));
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    return super.close();
  }
}