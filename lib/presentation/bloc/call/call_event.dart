abstract class CallEvent {}

// Jab user khud button daba kar call shuru kare
class StartCall extends CallEvent {
  final String conversationId;
  final String currentUserId;
  final String receiverId;
  final String receiverName;

  StartCall({
    required this.conversationId,
    required this.currentUserId,
    required this.receiverId,
    required this.receiverName,
  });
}

// Jab background listener ko incoming call ka socket event mile
class IncomingCallReceived extends CallEvent {
  final String conversationId;
  final String callerId;
  final String callerName;

  IncomingCallReceived({
    required this.conversationId,
    required this.callerId,
    required this.callerName,
  });
}

// Target call utha le (answerCall)
class AcceptCall extends CallEvent {}

// Call kaat di jaye ya reject ho (endCall)
class DeclineCall extends CallEvent {
  final bool isRejectedReason;
  DeclineCall({this.isRejectedReason = false});
}