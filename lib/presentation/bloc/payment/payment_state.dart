class PaymentState {
  final String holder;
  final String number;
  final String expiry;
  final String cvv;
  final bool showCvv;
  final int selectedIndex;

  PaymentState({
    this.holder = "ZAYN MALIK",
    this.number = "**** **** **** 5000",
    this.expiry = "01/29",
    this.cvv = "***",
    this.showCvv = false,
    this.selectedIndex = 0,
  });

  PaymentState copyWith({
    String? holder,
    String? number,
    String? expiry,
    String? cvv,
    bool? showCvv,
    int? selectedIndex,
  }) {
    return PaymentState(
      holder: holder ?? this.holder,
      number: number ?? this.number,
      expiry: expiry ?? this.expiry,
      cvv: cvv ?? this.cvv,
      showCvv: showCvv ?? this.showCvv,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}