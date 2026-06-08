import '../../enums/otp_purpose.dart';

extension OtpPurposeExtension on OtpPurpose {
  String get apiValue {
    switch (this) {
      case OtpPurpose.phoneVerification:
        return "phone-verification";

      case OtpPurpose.forgotPassword:
        return "forgot-password";
    }
  }
}