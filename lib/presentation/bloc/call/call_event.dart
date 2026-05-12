abstract class CallEvent{}
class StartCall extends CallEvent {
  final String userName;
  StartCall(this.userName);
}

class DeclineCall extends CallEvent {}
