import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/helper/constants/colors_resources.dart';
import '../../core/helper/constants/dimensions-resource.dart';
import '../../core/helper/constants/images-resources.dart';
import '../../core/helper/constants/strings-resource.dart';
import '../../core/routes/AppRoutes.dart';
import '../../widgets/cutom_button.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              ImageResource.GET_STARTED_BACKGROUND,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: DimensionsResources.D_24.w,
                vertical: DimensionsResources.D_20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: DimensionsResources.D_106.w,
                    height: DimensionsResources.D_106.h,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(DimensionsResources.D_12.w),
                    child: Image.asset(
                      ImageResource.OMINGO_LOCATION_LOGO_IMG,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: DimensionsResources.D_40.h),
                  // Welcome Text
                  Text(
                    StringResources.welcomeToOmnigo,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontSize: DimensionsResources.FONT_SIZE_EXTRA_MEDIUM_LARGE.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  // Get Started Button
                  CustomButton(
                    text: StringResources.getStarted,
                    color: AppColors.white,
                    textColor: AppColors.homeBackground,
                    borderRadius: DimensionsResources.D_30.r,
                    borderColor: AppColors.white,
                    fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp,
                    fontWeight: FontWeight.bold,
                    onClick: () {
                      Navigator.pushNamed(context, AppRoutes.onboarding);
                    },
                  ),
                  SizedBox(height: DimensionsResources.D_20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
