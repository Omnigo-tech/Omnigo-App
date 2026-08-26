import '../constants/dimensions-resource.dart';
import '../constants/strings-resource.dart';

extension ValidationExtension on String? {
  String? validateName() {
    if (this == null || this!.trim().isEmpty) {
      return StringResources.nameRequired;
    }
    return null;
  }

  String? validateEmail() {
    if (this == null || this!.isEmpty) {
      return StringResources.emailRequired;
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(this!)) {
      return StringResources.validEmailRequired;
    }
    return null;
  }

  String? validatePassword() {
    if (this == null || this!.isEmpty) {
      return StringResources.passwordRequired;
    }
    if (this!.length < DimensionsResources.INT_6) {
      return StringResources.minPasswordLength;
    }
    return null;
  }

  String? validatePhone() {
    if (this == null || this!.isEmpty) {
      return StringResources.phoneRequired;
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(this!)) {
      return StringResources.digitsOnly;
    }
    if (this!.length != DimensionsResources.INT_10) {
      return StringResources.tenDigitsRequired;
    }
    if (!this!.startsWith('3')) {
      return StringResources.startWithThree;
    }
    return null;
  }
  String? validateDigit() {
    if (this == null || this!.isEmpty) return "";
    if (!RegExp(r'^[0-9]$').hasMatch(this!)) return "";
    return null;
  }

  String formatPhone() {
    final phone = this?.trim() ?? '';
    return phone.startsWith('0') ? phone : '0$phone';
  }
}
