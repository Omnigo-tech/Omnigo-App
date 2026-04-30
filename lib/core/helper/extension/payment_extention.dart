extension PaymentValidation on String {
  String? validateMobile() {
    if (isEmpty) return "Phone number is required";
    final regex = RegExp(r'^03\d{9}$');
    return regex.hasMatch(this)
        ? null
        : "Enter valid 11-digit number (03xx...)";
  }

  String? validateCNIC() {
    if (isEmpty) return "CNIC is required";
    final regex = RegExp(r'^\d{13}$');
    return regex.hasMatch(this)
        ? null
        : "CNIC must be 13 digits";
  }

  String? validateCardNumber() {
    if (isEmpty) return "Card number required";
    if (length < 16) return "Enter valid card number";
    return null;
  }

  String? validateCvv() {
    if (isEmpty) return "CVV required";
    if (length < 3) return "Invalid CVV";
    return null;
  }

  String? validateExpiry() {
    if (isEmpty) return "Expiry required";
    return null;
  }

  String? validateHolder() {
    if (isEmpty) return "Card holder required";
    return null;
  }

  String? validateIban() {
    if (isEmpty) return "IBAN required";
    if (length < 10) return "Invalid IBAN";
    return null;
  }
}