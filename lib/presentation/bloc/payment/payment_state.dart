class PaymentState {
  final String holder;
  final String phoneNumber;
  final String cardNumber;
  final String expiry;
  final String cvv;
  final bool showCvv;
  final int selectedIndex;
  final int walletIndex;
  final int bankIndex;

  PaymentState({
    this.holder = "ZAYN MALIK",
    this.cardNumber = "**** **** **** 5000",
    this.phoneNumber = "03331234567",
    this.expiry = "01/29",
    this.cvv = "***",
    this.showCvv = false,
    this.selectedIndex = 0,
    this.walletIndex = -1,
    this.bankIndex = -1,
  });

  PaymentState copyWith({
    String? holder,
    String? phoneNumber,
    String? cardNumber,
    String? expiry,
    String? cvv,
    bool? showCvv,
    int? selectedIndex,
    int? bankIndex,
    int? walletIndex,
  }) {
    return PaymentState(
      holder: holder ?? this.holder,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      cardNumber: cardNumber ?? this.cardNumber,
      expiry: expiry ?? this.expiry,
      cvv: cvv ?? this.cvv,
      showCvv: showCvv ?? this.showCvv,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      walletIndex: walletIndex ?? this.walletIndex,
      bankIndex: bankIndex ?? this.bankIndex,
    );
  }
}