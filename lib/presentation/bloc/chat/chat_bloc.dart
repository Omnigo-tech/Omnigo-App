import 'package:bloc/bloc.dart';
import 'package:grocery_app/data/models/message_model.dart';

import 'chat_event.dart';
import 'chat_state.dart'; // Define your message model (id, text, isUser)

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState.initial()) {
    on<FetchMessages>(_onFetchMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
  }

  void _onFetchMessages(FetchMessages event, Emitter<ChatState> emit) {
    // Implement logic to fetch initial messages from a repository (optional)
  }

  // chat_bloc.dart mein

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    // 1. User ka message UI par dikhayen
    final userMsg = MessageModel(
      id: DateTime.now().toString(),
      text: event.message,
      isUser: true,
    );

    final updatedMessages = List<MessageModel>.from(state.messages)..add(userMsg);
    emit(state.copyWith(messages: updatedMessages));

    // 2. Testing ke liye delay (Backend simulation)
    await Future.delayed(Duration(seconds: 1));

    // 3. Fake "Bot" reply generate karein
    final botReply = MessageModel(
      id: DateTime.now().toString(),
      text: "Testing: Reply for '${event.message}'",
      isUser: false,
    );

    final withBotMessages = List<MessageModel>.from(state.messages)..add(botReply);
    emit(state.copyWith(messages: withBotMessages));
  }

  void _onReceiveMessage(ReceiveMessage event, Emitter<ChatState> emit) {
    final newAIMessage = MessageModel(
      id: DateTime.now().toString(),
      text: event.message,
      isUser: false,
    );
    final updatedMessages = List<MessageModel>.from(state.messages)..add(newAIMessage);
    emit(state.copyWith(messages: updatedMessages, status: ChatStatus.loaded));
  }
}