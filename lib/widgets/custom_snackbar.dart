import 'package:flutter/material.dart';

class CustomSnackBar {
  CustomSnackBar._();

  static void show(
      BuildContext context,
      String message, {
        bool isError = false,
        Duration duration = const Duration(seconds: 2),
      }) {

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [

            Icon(
              isError
                  ? Icons.error_outline
                  : Icons.check_circle_outline,
              color: Colors.white,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                message,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        backgroundColor:
        isError
            ? const Color(0xffE53935)
            : const Color(0xff2E7D32),

        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        elevation: 8,

        dismissDirection: DismissDirection.horizontal,

        duration: duration,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  static void success(
      BuildContext context,
      String message,
      ) {
    show(
      context,
      message,
      isError: false,
    );
  }

  static void error(
      BuildContext context,
      String message,
      ) {
    show(
      context,
      message,
      isError: true,
    );
  }
}