import '../../../core/network/api_service.dart';
import '../../models/conversation_response_model.dart';
import '../../models/chat_messages_response_model.dart';

class ChatRepository {
  final ApiService _apiService;

  ChatRepository(this._apiService);

  Future<ConversationResponseModel> createConversation(String orderId) async {
    return await _apiService.createConversation({"orderId": orderId});
  }

  Future<ChatMessagesResponseModel> getChatMessages(String conversationId) async {
    return await _apiService.getChatMessages(conversationId);
  }
}