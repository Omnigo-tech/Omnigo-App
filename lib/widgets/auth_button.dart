import 'package:flutter/material.dart';
import '../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/sizes.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const AuthButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.border,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}


