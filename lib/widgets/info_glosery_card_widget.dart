import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/dimensions-resource.dart';

class InfoGloseryCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const InfoGloseryCardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.only(right: DimensionsResources.D_10.sp),
      padding:  EdgeInsets.all(DimensionsResources.D_12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DimensionsResources.D_14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.08),
            blurRadius: DimensionsResources.D_4,
            offset: const Offset(DimensionsResources.D_0, DimensionsResources.D_2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            width: DimensionsResources.D_32.w,
            height: DimensionsResources.D_32.h,
            fit: BoxFit.contain,
          ),
           SizedBox(width: DimensionsResources.D_8.w),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.dmSans(
                    fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary
                ),
              ),
              Text(
                subtitle,
                style:GoogleFonts.dmSans(
                    fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}