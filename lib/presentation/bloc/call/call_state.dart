enum CallStatus { idle, ringing, ended }

class CallState {
  final CallStatus status;
  final String userName;

  CallState({required this.status, this.userName = ''});
}