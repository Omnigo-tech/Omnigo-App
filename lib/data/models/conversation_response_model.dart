class ConversationResponseModel {
  final bool success;
  final ConversationData? conversation;

  ConversationResponseModel({required this.success, this.conversation});

  factory ConversationResponseModel.fromJson(Map<String, dynamic> json) {
    return ConversationResponseModel(
      success: json['success'] ?? false,
      conversation: json['conversation'] != null
          ? ConversationData.fromJson(json['conversation'])
          : null,
    );
  }
}

class ConversationData {
  final String id;
  final String orderId;
  final String customerId;
  final String riderId;
  final String lastMessage;

  ConversationData({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.riderId,
    required this.lastMessage,
  });

  factory ConversationData.fromJson(Map<String, dynamic> json) {
    return ConversationData(
      id: json['_id'] ?? '',
      orderId: json['orderId'] ?? '',
      customerId: json['customerId'] ?? '',
      riderId: json['riderId'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
    );
  }
}