import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: DimensionsResources.D_70.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: DimensionsResources.D_20.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: DimensionsResources.D_18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: DimensionsResources.D_8.h),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                  color: Colors.grey,
                  height: DimensionsResources.D_2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}