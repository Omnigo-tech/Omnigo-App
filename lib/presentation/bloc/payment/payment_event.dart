abstract class PaymentEvent {}

class UpdateHolder extends PaymentEvent {
  final String value;
  UpdateHolder(this.value);
}

class UpdatePhoneNumber extends PaymentEvent {
  final String value;
  UpdatePhoneNumber(this.value);
}

class UpdateCardNumber extends PaymentEvent {
  final String value;
  UpdateCardNumber(this.value);
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
class ChangeWalletIndex extends PaymentEvent {
  final int index;
  ChangeWalletIndex(this.index);
}

class ChangeBankIndex extends PaymentEvent {
  final int index;
  ChangeBankIndex(this.index);
}
