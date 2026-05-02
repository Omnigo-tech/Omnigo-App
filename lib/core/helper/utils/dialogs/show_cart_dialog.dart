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
}