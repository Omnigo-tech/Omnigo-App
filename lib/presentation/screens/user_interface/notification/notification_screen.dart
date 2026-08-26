import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';

import '../../../../core/helper/constants/colors_resources.dart';
import '../../../../core/helper/constants/dimensions-resource.dart';
import '../../../../core/helper/constants/images-resources.dart';
import '../../../../core/helper/constants/strings-resource.dart';
import '../../../../core/helper/utils/dialogs/show_cart_dialog.dart';
import '../../../../core/helper/utils/launcher_helper.dart';
import '../../../../widgets/tracking_info_card.dart';

class NotificationScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const NotificationScreen({super.key, required this.data});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Map<String, dynamic> tracking;
  @override
  void initState() {
    super.initState();

    tracking = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Notifications", showBackButton: true),
      body: Column(
        children: [
          Container(
            child: Container(
              child: TrackingInfoCard(
                status: tracking['status'] ?? "",
                estimatedTime: tracking['estimatedTime'] ?? "",
                riderName: tracking['deliveryHeroName'] ?? "",
                riderTitle: StringResources.deliveryhero,
                riderImage: ImageResource.RIDER_IMG,

                clockIcon: ImageResource.CLOCK_ICON,
                bikeIcon: ImageResource.BYKE_ICON,
                deliveredIcon: ImageResource.HOME_DELIVERED_ICON,
                locationIcon: ImageResource.LOCATION_ICON,
                messageIcon: ImageResource.MESSAGE_ICON,
                callIcon: ImageResource.CALL_ICON,

                primaryColor: AppColors.primary,
                iconBgColor: AppColors.fieldBg,
                iconColor: AppColors.primary,

                onMessageTap: () {
                  Navigator.pushNamed(context, '/chat');
                },

                onCallTap: () {
                },
              ),
            ),
          ),
          SizedBox(height: DimensionsResources.D_20.w),
          Expanded(
            child: ListView.separated(
              itemCount: 1, // Change this to your list length
              padding: EdgeInsets.only(top: 10.h),
              separatorBuilder: (context, index) => SizedBox(height: 15.h),
              itemBuilder: (context, index) {
                return _buildNotificationItem();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: DimensionsResources.D_20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9), // Light green background from image
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order #345",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "3:57 PM",
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  "Your Order is Confirmed. Please check everything is okay",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          // The orange menu/details icon
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.subject, color: Colors.white, size: 20.w),
          ),
        ],
      ),
    );
  }
}
