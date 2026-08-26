class ChatMessagesResponseModel {
  final bool success;
  final List<MessageDetailModel> messages;

  ChatMessagesResponseModel({required this.success, required this.messages});

  factory ChatMessagesResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatMessagesResponseModel(
      success: json['success'] ?? false,
      messages: (json['messages'] as List?)
          ?.map((e) => MessageDetailModel.fromJson(e))
          .toList() ?? [],
    );
  }
}

class MessageDetailModel {
  final String id;
  final String conversationId;
  final ChatUser sender;
  final ChatUser receiver;
  final String text;
  final String createdAt;

  MessageDetailModel({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.createdAt,
  });

  factory MessageDetailModel.fromJson(Map<String, dynamic> json) {
    return MessageDetailModel(
      id: json['_id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      sender: ChatUser.fromJson(json['sender'] ?? {}),
      receiver: ChatUser.fromJson(json['receiver'] ?? {}),
      // Backend par kuch jagah 'content' hai aur kuch jagah 'message', hum dono handle kar rahe hain
      text: json['message'] ?? json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class ChatUser {
  final String id;
  final String name;

  ChatUser({required this.id, required this.name});

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}