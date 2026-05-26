// lib/widgets/auth_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/dimensions-resource.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading; // New flag for loading state

  const AuthButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false, // Default value false rakhi hai
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return SizedBox(
        height: 56.h, // Proportional height
        width: double.infinity,
        child: ElevatedButton(
          // Loading ke dauran click disable ho jayega
            onPressed: isLoading ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLoading
                  ? AppColors.brandedBlue
                  : AppColors.homeBackground,
              disabledBackgroundColor: AppColors.brandedBlue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DimensionsResources.D_12
                    .r), // Using standard radius resource
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
              text,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.white,
                fontSize: DimensionsResources.FONT_SIZE_1X_EXTRA_MEDIUM.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            // Agar loading true ho to text ke right side par spinkit chalega
            if (isLoading) ...[
    SizedBox(width: DimensionsResources.D_20.w),
    SpinKitFadingCircle(
    color: AppColors.white,
    size: 30.r, // Clean professional dimension
    )
    ],
    ],
    ),
    ),
    );
  }
}