import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';

import '../../../../widgets/cutom_button.dart';
import '../../../routes/AppRoutes.dart';

class GlobalDialogs {
  static void showAddedToCartDialog(BuildContext context,
      {List? selectedItems}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              DimensionsResources.RADIUS_EXTRA_LARGE.r,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(DimensionsResources.D_20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: AppColors.darkGreen,
                  size: DimensionsResources.D_80.sp,
                ),
                SizedBox(height: DimensionsResources.D_20.h),
                Text(
                  StringResources.addedToCart,
                  style: GoogleFonts.dmSans(
                    fontSize:
                    DimensionsResources.FONT_SIZE_LARGE.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: DimensionsResources.D_10.h),
                Text(
                  StringResources.itemAddedSuccess,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize:
                    DimensionsResources.FONT_SIZE_MEDIUM.sp,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: DimensionsResources.D_24.h),
                CustomButton(
                  onClick: () {
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<GroceryDetailBloc>(),
                          child: MyCartScreen(),
                        ),
                      ),
                    );
                  },
                  text: StringResources.goToCart,
                  textColor: AppColors.white,
                  borderRadius: DimensionsResources.D_12.r,
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.groceryhome,
                          (route) => false,
                    );
                  },
                  child: Text(
                    StringResources.continueShopping,
                    style: GoogleFonts.dmSans(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  static void showStatusDialog({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String subtitle,
    required String primaryButtonText,
    required VoidCallback onPrimaryClick,
    required VoidCallback onSecondaryClick,
    bool isSuccess = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionsResources.RADIUS_EXTRA_LARGE.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(DimensionsResources.D_20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Close Button for Failure state (image_008959.png)
                if (!isSuccess)
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      icon: Icon(Icons.close, size: 24.sp),
                    ),
                  ),

                // Illustration (Success/Failure)
                Image.asset(
                  imagePath,
                  height: 180.h,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: DimensionsResources.D_20.h),

                // Title - Using League Spartan as per your design preference
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),

                SizedBox(height: DimensionsResources.D_10.h),

                // Subtitle
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: DimensionsResources.D_24.h),
                CustomButton(
                  onClick: onPrimaryClick,
                  text: primaryButtonText,
                  textColor: AppColors.white,
                  borderRadius: DimensionsResources.D_12.r,
                ),
                SizedBox(height: DimensionsResources.D_10.h),
                TextButton(
                  onPressed: onSecondaryClick,
                  child: Text(
                    "Back to home",
                    style: GoogleFonts.dmSans(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}