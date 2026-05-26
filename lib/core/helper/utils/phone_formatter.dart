class PhoneFormatter {
  static String format(String phone) {
    phone = phone.trim();

    if (phone.startsWith('0')) {
      return phone;
    }

    return '0$phone';
  }
}