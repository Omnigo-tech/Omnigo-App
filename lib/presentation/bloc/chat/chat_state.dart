import 'package:grocery_app/data/models/message_model.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState {
  final List<MessageModel> messages;
  final ChatStatus status;
  final String? errorMessage;

  ChatState({required this.messages, required this.status, this.errorMessage});

  factory ChatState.initial() =>
      ChatState(messages: [], status: ChatStatus.initial);

  ChatState copyWith({
    List<MessageModel>? messages,
    ChatStatus? status,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
