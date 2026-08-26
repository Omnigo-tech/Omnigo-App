import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/remote/socket_service.dart';
import '../../../data/datasource/repositories/chat_repository.dart';
import '../../../data/models/message_model.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;
  final SocketService socketService;
  StreamSubscription? _socketSubscription;

  ChatBloc(this.repository, this.socketService) : super(ChatState.initial()) {
    on<FetchMessages>(_onFetchMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  void _onFetchMessages(FetchMessages event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    try {
      // 1. Join Socket Identity Rooms
      socketService.joinUserRoom(event.currentUserId);
      socketService.joinConversationRoom(event.conversationId);

      // 2. Fetch History over HTTP API
      final response = await repository.getChatMessages(event.conversationId);

      final mappedMessages = response.messages.map((msg) {
        return MessageModel(
          id: msg.id,
          text: msg.text,
          isUser: msg.sender.id == event.currentUserId,
        );
      }).toList();

      emit(state.copyWith(status: ChatStatus.loaded, messages: mappedMessages));

      // 3. Keep listening to real-time streams
      await _socketSubscription?.cancel();
      _socketSubscription = socketService.orderStatusStream.listen((data) {
        if (data['event'] == 'receiveMessage' && data['conversationId'] == event.conversationId) {
          add(ReceiveMessage(rawMessage: data, currentUserId: event.currentUserId));
        }
      });
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.error, errorMessage: e.toString()));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    // Send live signal across WebSocket line
    socketService.emitMessage(
      conversationId: event.conversationId,
      sender: event.senderId,
      receiver: event.receiverId,
      message: event.message,
    );

    // Optimistic UI update immediately
    final localMsg = MessageModel(
      id: DateTime.now().toString(),
      text: event.message,
      isUser: true,
    );
    final updated = List<MessageModel>.from(state.messages)..add(localMsg);
    emit(state.copyWith(messages: updated));
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    final senderId = event.rawMessage['sender'] is Map
        ? event.rawMessage['sender']['_id']
        : event.rawMessage['sender'].toString();

    final liveMsg = MessageModel(
      id: event.rawMessage['_id'] ?? DateTime.now().toString(),
      text: event.rawMessage['message'] ?? event.rawMessage['content'] ?? '',
      isUser: senderId == event.currentUserId,
    );

    // Prevent duplicate injections
    if (state.messages.any((m) => m.id == liveMsg.id)) return;

    final updated = List<MessageModel>.from(state.messages)..add(liveMsg);
    emit(state.copyWith(messages: updated));
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    return super.close();
  }
}