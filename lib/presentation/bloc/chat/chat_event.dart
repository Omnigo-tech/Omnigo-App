abstract class ChatEvent {}

class FetchMessages extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String message;
  SendMessage(this.message);
}

class ReceiveMessage extends ChatEvent {
  final String message;
  ReceiveMessage(this.message);
}