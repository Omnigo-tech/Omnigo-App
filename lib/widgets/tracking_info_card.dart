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

  // Helper function status sequence level check karne ke liye
  int _getStatusStep(String currentStatus) {
    switch (currentStatus.toLowerCase()) {
      case 'pending':
      case 'confirmed':
        return 1; // Order placed/confirmed stage
      case 'preparing':
        return 2; // Kitchen / preparing active
      case 'ongoing':
        return 3; // On the way (Rider moving)
      case 'delivered':
        return 4; // Reached destination
      case 'cancelled':
        return 0; // Edge handling if order drops
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentStep = _getStatusStep(status);

    return Column(
      children: [
        /// STATUS LAYER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              status.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: status.toLowerCase() == 'cancelled' ? Colors.red : AppColors.black,
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.border, width: 0.5.w),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    clockIcon,
                    width: 16.w,
                    height: 16.h,
                    colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    estimatedTime,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 25.h),

        /// DYNAMIC PROGRESS BAR
        Row(
          children: [
            // Step 1: Order Placed Icon (Hamesha active rahega agar cancelled na ho)
            Icon(
              Icons.check_circle,
              color: currentStep >= 1 ? primaryColor : AppColors.border,
              size: 24.sp,
            ),

            // Line 1: Placed -> Preparing
            Expanded(
              child: Container(
                height: 4.h,
                color: currentStep >= 2 ? primaryColor : AppColors.border,
              ),
            ),

            // Step 2: Kitchen / Preparing Icon
            SvgPicture.asset(
              bikeIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                currentStep >= 2 ? primaryColor : AppColors.border,
                BlendMode.srcIn,
              ),
            ),

            // Line 2: Preparing -> Ongoing (On the Way)
            Expanded(
              child: Container(
                height: 4.h,
                color: currentStep >= 3 ? primaryColor : AppColors.border,
              ),
            ),

            // Step 3: Out for Delivery / Ongoing Icon
            SvgPicture.asset(
              deliveredIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                currentStep >= 3 ? primaryColor : AppColors.border,
                BlendMode.srcIn,
              ),
            ),

            // Line 3: Ongoing -> Delivered
            Expanded(
              child: Container(
                height: 4.h,
                color: currentStep >= 4 ? primaryColor : AppColors.border,
              ),
            ),

            // Step 4: Reached / Delivered Destination Icon
            SvgPicture.asset(
              locationIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: ColorFilter.mode(
                currentStep >= 4 ? primaryColor : AppColors.border,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),

        SizedBox(height: 30.h),

        /// RIDER INFO LAYER
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
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.grey),
                  ),
                  Text(
                    riderName,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.black),
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