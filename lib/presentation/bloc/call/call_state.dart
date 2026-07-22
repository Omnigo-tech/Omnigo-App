enum CallStatus { idle, incoming, ringing, connected, ended, error }

class CallState {
  final CallStatus status;
  final String userName;
  final String? conversationId;
  final String? targetId;
  final String? errorMessage;

  CallState({
    required this.status,
    this.userName = "",
    this.conversationId,
    this.targetId,
    this.errorMessage,
  });

  factory CallState.initial() => CallState(status: CallStatus.idle);

  CallState copyWith({
    CallStatus? status,
    String? userName,
    String? conversationId,
    String? targetId,
    String? errorMessage,
  }) {
    return CallState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      conversationId: conversationId ?? this.conversationId,
      targetId: targetId ?? this.targetId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}