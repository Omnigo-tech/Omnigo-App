abstract class PaymentEvent {}

class UpdateHolder extends PaymentEvent {
  final String value;
  UpdateHolder(this.value);
}

class UpdateNumber extends PaymentEvent {
  final String value;
  UpdateNumber(this.value);
}

class UpdateExpiry extends PaymentEvent {
  final String value;
  UpdateExpiry(this.value);
}

class UpdateCvv extends PaymentEvent {
  final String value;
  UpdateCvv(this.value);
}

class ToggleCvv extends PaymentEvent {}

class ChangeCardIndex extends PaymentEvent {
  final int index;
  ChangeCardIndex(this.index);
}
