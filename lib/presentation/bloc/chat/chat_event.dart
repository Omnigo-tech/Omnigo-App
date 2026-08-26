abstract class ChatEvent {}

class FetchMessages extends ChatEvent {
  final String conversationId;
  final String currentUserId;
  FetchMessages({required this.conversationId, required this.currentUserId});
}

class SendMessage extends ChatEvent {
  final String conversationId;
  final String senderId;
  final String receiverId;
  final String message;
  SendMessage({required this.conversationId, required this.senderId, required this.receiverId, required this.message});
}

class ReceiveMessage extends ChatEvent {
  final Map<String, dynamic> rawMessage;
  final String currentUserId;
  ReceiveMessage({required this.rawMessage, required this.currentUserId});
}