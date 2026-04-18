import 'package:flutter/foundation.dart';

class AppUtils {
  static void printMessage(String msg) {
    if (kDebugMode) print(msg);
  }
}
