import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/helper/constants/colors_resources.dart';

class TrackingInfoCard extends StatelessWidget {
  final String status;
  final String estimatedTime;
  final String riderName;
  final String riderTitle;
  final String riderImage;

  final String clockIcon;
  final String bikeIcon;
  final String deliveredIcon;
  final String locationIcon;
  final String messageIcon;
  final String callIcon;

  final Color primaryColor;
  final Color iconBgColor;
  final Color iconColor;

  final VoidCallback onMessageTap;
  final VoidCallback onCallTap;

  const TrackingInfoCard({
    super.key,
    required this.status,
    required this.estimatedTime,
    required this.riderName,
    required this.riderTitle,
    required this.riderImage,
    required this.clockIcon,
    required this.bikeIcon,
    required this.deliveredIcon,
    required this.locationIcon,
    required this.messageIcon,
    required this.callIcon,
    required this.primaryColor,
    required this.iconBgColor,
    required this.iconColor,
    required this.onMessageTap,
    required this.onCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// STATUS
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(status, style: Theme.of(context).textTheme.titleLarge),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.whiteTranslucent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.border, width: 0.5.w),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    clockIcon,
                    width: 16.w,
                    height: 16.h,
                    colorFilter: ColorFilter.mode(
                      primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),

                  SizedBox(width: 4.w),

                  Text(
                    estimatedTime,
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 25.h),

        /// PROGRESS BAR
        Row(
          children: [
            Icon(Icons.check_circle, color: primaryColor, size: 24.sp),

            Expanded(
              child: Container(height: 4.h, color: primaryColor),
            ),

            SvgPicture.asset(
              bikeIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),

            Expanded(
              child: Container(height: 4.h, color: AppColors.border),
            ),

            SvgPicture.asset(
              deliveredIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),

            Expanded(
              child: Container(height: 4.h, color: AppColors.border),
            ),

            SvgPicture.asset(
              locationIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
          ],
        ),

        SizedBox(height: 30.h),

        /// RIDER INFO
        Row(
          children: [
            CircleAvatar(
              backgroundImage: Image.asset(riderImage).image,
              radius: 25.r,
              backgroundColor: AppColors.itemBackground,
            ),

            SizedBox(width: 15.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    riderTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppColors.grey),
                  ),
                  Text(
                    riderName,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: AppColors.black),
                  ),
                ],
              ),
            ),

            _buildActionIcon(messageIcon, onMessageTap),

            SizedBox(width: 10.w),

            _buildActionIcon(callIcon, onCallTap),
          ],
        ),
      ],
    );
  }

  Widget _buildActionIcon(String icon, VoidCallback onTap) {
    return Container(
      width: 46.w,
      height: 46.h,
      decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
      child: IconButton(
        onPressed: onTap,
        icon: SvgPicture.asset(
          icon,
          width: 20.w,
          colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
        ),
      ),
    );
  }
}
