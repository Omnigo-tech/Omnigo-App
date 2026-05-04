import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/sizes.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/grocery_home_screen.dart';
import 'package:grocery_app/widgets/auth_button.dart';

import 'cutom_button.dart';

class ConfirmOrder extends StatelessWidget {
  const ConfirmOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 150.h),
            Expanded(
              child: Center(
                child: Image.asset(
                  ImageResource.CONFIRM_ORDER,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: DimensionsResources.D_50.h),
            Text(
              StringResources.orderConfirmation,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: DimensionsResources.FONT_SIZE_LARGE,
              ),
            ),
            Text(
              StringResources.confirm,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: DimensionsResources.FONT_SIZE_LARGE,
              ),
            ),
            SizedBox(height: DimensionsResources.D_20.h),
            Text(
              StringResources.orderConfirmationSubstr_1,
              style: TextStyle(
                color: AppColors.lightText,
                fontSize: DimensionsResources.FONT_SIZE_SMALL,
              ),
            ),
            Text(
              StringResources.orderConfirmationSubstr_2,
              style: TextStyle(
                color: AppColors.lightText,
                fontSize: DimensionsResources.FONT_SIZE_SMALL,
              ),
            ),

            SizedBox(height: DimensionsResources.D_50.h),
            Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: AuthButton(text: StringResources.trackOrder, onTap: () {}),
            ),

               CustomButton(
                onClick: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => GroceryHomeScreen(nameCategories: "")),
                  );
                },
                text: StringResources.backToHome,
                textColor: AppColors.black,
                borderRadius: DimensionsResources.RADIUS_DEFAULT.r,
                borderColor: AppColors.white,
                color: AppColors.white,
              ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
