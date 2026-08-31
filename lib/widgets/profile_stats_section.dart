
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/helper/constants/colors_resources.dart';
import '../../../../../core/helper/constants/dimensions-resource.dart';
import '../../../../../core/helper/constants/strings-resource.dart';
import 'profile_stats_card.dart';

class ProfileStatsSection extends StatelessWidget {
final int orders;
final int pendingOrders;
final int savedItems;
final int cartItems;

const ProfileStatsSection({
super.key,
required this.orders,
required this.pendingOrders,
required this.savedItems,
required this.cartItems,
});

@override
Widget build(BuildContext context) {
return Padding(
padding: EdgeInsets.symmetric(
horizontal: DimensionsResources.D_10.w,
),
child: Container(
padding: EdgeInsets.symmetric(
vertical: DimensionsResources.D_12.h,
),
decoration: BoxDecoration(
color: AppColors.lightBlueBackground,
borderRadius: BorderRadius.circular(
DimensionsResources.RADIUS_EXTRA_LARGE.r,
),
boxShadow: [
BoxShadow(
color: AppColors.black.withOpacity(0.05),
blurRadius: DimensionsResources.D_12.r,
offset: const Offset(
DimensionsResources.D_0,
DimensionsResources.D_4,
),
),
],
),
child: Row(
children: [
Expanded(
child: ProfileStatsCard(
icon: Icons.shopping_bag_outlined,
title: StringResources.orders,
value: orders.toString(),
),
),

Expanded(
child: ProfileStatsCard(
icon: Icons.local_shipping_outlined,
title: StringResources.inProgress,
value: pendingOrders.toString(),
),
),

Expanded(
child: ProfileStatsCard(
icon: Icons.favorite_border,
title: StringResources.saved,
value: savedItems.toString(),
),
),

Expanded(
child: ProfileStatsCard(
icon: Icons.shopping_cart_outlined,
title: StringResources.cart,
value: cartItems.toString(),
),
),
],
),
),
);
}
}
