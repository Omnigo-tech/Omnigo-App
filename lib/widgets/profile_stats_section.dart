import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/constants/colors_resources.dart';
import 'profile_stats_card.dart';

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.lightBlueBackground,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ProfileStatsCard(
              icon: Icons.shopping_bag_outlined,
              title: "Orders",
              value: "12",
            ),

            ProfileStatsCard(
              icon: Icons.local_shipping_outlined,
              title: "In Progress",
              value: "2",
            ),

            ProfileStatsCard(
              icon: Icons.favorite_border,
              title: "Saved",
              value: "8",
            ),

            ProfileStatsCard(
              icon: Icons.local_offer_outlined,
              title: "Offers",
              value: "5",
            ),
          ],
        ),
      ),
    );
  }
}