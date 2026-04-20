import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/dimensions-resource.dart';

class CustomCircleBtn extends StatelessWidget {
  final IconData icon;
  final bool isAdd;
  final VoidCallback? onTap;
  final double size;
  final double borderRadius;
  final double iconSize;

  const CustomCircleBtn({
    super.key,
    required this.icon,
    this.isAdd = false,
    this.onTap,
    this.size = DimensionsResources.D_32,
    this.borderRadius = DimensionsResources.D_100,
    this.iconSize = DimensionsResources.D_18,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.h,
        width: size.w,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.primary : AppColors.border,
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
        child: Icon(
          icon,
          size: iconSize.sp,
          color: isAdd ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }
}