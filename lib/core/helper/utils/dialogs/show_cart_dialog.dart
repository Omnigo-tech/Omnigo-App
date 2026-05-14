import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';

import '../../../../presentation/bloc/call/call_bloc.dart';
import '../../../../presentation/bloc/call/call_event.dart';
import '../../../../widgets/cutom_button.dart';
import '../../../routes/AppRoutes.dart';
import '../launcher_helper.dart';

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
    VoidCallback? onSecondaryClick, // Made optional
    String? secondaryButtonText,    // Added custom text
    bool isSuccess = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white, // Ensure white background
          insetPadding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_20.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionsResources.RADIUS_EXTRA_LARGE.r),
          ),
          child: Stack( // Using Stack for the top-left cross icon
            children: [
              // 1. Cross Icon at Top Left
              Positioned(
                top: DimensionsResources.D_10.h,
                right: DimensionsResources.D_10.w,
                child: IconButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  icon: Icon(Icons.close, size: DimensionsResources.D_24.sp, color: AppColors.black),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(
                    DimensionsResources.D_20.w,
                    DimensionsResources.D_50.h, // Space for cross icon
                    DimensionsResources.D_20.w,
                    DimensionsResources.D_20.w
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      imagePath,
                      height: 100.h,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: DimensionsResources.D_20.h),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.leagueSpartan(
                        fontSize: DimensionsResources.D_20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),

                    SizedBox(height: DimensionsResources.D_10.h),

                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp,
                        color: AppColors.grey,
                      ),
                    ),

                    SizedBox(height: DimensionsResources.D_24.h),

                    // Primary Button
                    CustomButton(
                      onClick: onPrimaryClick,
                      text: primaryButtonText,
                      textColor: AppColors.white,
                      borderRadius: DimensionsResources.D_12.r,
                    ),

                    // 2. Secondary Button (Only shows if text and callback provided)
                    if (secondaryButtonText != null && onSecondaryClick != null) ...[
                      SizedBox(height: DimensionsResources.D_10.h),
                      TextButton(
                        onPressed: onSecondaryClick,
                        child: Text(
                          secondaryButtonText,
                          style: GoogleFonts.dmSans(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: DimensionsResources.D_16.sp,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  static void showCallDriverSheet(BuildContext context, {required String phoneNumber}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(DimensionsResources.D_24.w),
        decoration: BoxDecoration(
          color: AppColors.itemBackground,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(DimensionsResources.D_30.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  StringResources.callDriver,
                  style: GoogleFonts.changaOne(
                    fontSize: DimensionsResources.FONT_SIZE_EXTRA_LARGE.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    size: DimensionsResources.D_24.sp,
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),

            SizedBox(height: DimensionsResources.D_8.h),

            Text(
              StringResources.callDirectlyHint,
              style: GoogleFonts.abel(
                fontSize: DimensionsResources.FONT_SIZE_2X_EXTRA_MEDIUM.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.darkSecondary,
              ),
            ),

            SizedBox(height: DimensionsResources.D_30.h),

            SizedBox(
              width: double.infinity,
              height: DimensionsResources.D_56.h,
              child: CustomButton(
                onClick: () {
                  LauncherHelper.makePhoneCall(phoneNumber);
                  Navigator.pop(context);
                },
                text: StringResources.usePhoneDialer,
                textColor: AppColors.black,
                color: AppColors.border,
                borderColor: AppColors.grey,
              ),
            ),

            SizedBox(height: DimensionsResources.D_12.h),

            SizedBox(
              width: double.infinity,
              height: DimensionsResources.D_56.h,
              child: CustomButton(
                onClick: () {
                  Navigator.pop(context);
                  context.read<CallBloc>().add(StartCall(StringResources.chatUserDefault));
                  Future.delayed(const Duration(milliseconds: 100), () {
                    Navigator.pushNamed(context, AppRoutes.call);
                  });
                },
                text: StringResources.appCall,
                textColor: AppColors.white,
                subText: StringResources.internetConnectionHint,
              ),
            ),

            SizedBox(height: DimensionsResources.D_50.h),
          ],
        ),
      ),
    );
  }}