import 'package:flutter/material.dart';

class CustomSnackBar {

  static void show(
      BuildContext context,
      String message, {
        bool isError = true,
      }) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),

        backgroundColor:
        isError ? Colors.red : Colors.green,

        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.all(12),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        duration: const Duration(seconds: 2),
      ),
    );
  }
}