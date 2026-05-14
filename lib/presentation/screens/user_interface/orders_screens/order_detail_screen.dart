import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';
import 'package:grocery_app/data/models/order_model.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_event.dart';
import 'package:grocery_app/widgets/cutom_button.dart';
import 'package:intl/intl.dart';

import '../checkout_summary/checkout_summary_screen.dart';
import '../review/review_screen.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  Color getStatusColor(String status) {
    switch (status) {
      case "pending":
        return AppColors.pending;
      case "delivered":
        return AppColors.delivered;
      case "cancelled":
        return AppColors.red;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text("${StringResources.orderDetail}${order.id}"),
        elevation: DimensionsResources.D_0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(DimensionsResources.D_16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.status == "delivered"
                      ? StringResources.deliveryCompleted
                      : "${StringResources.order} ${order.status}",
                  style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                    "6:30 pm",
                    style: textTheme.bodyLarge?.copyWith(color: AppColors.primaryBlue)
                ),
              ],
            ),

            SizedBox(height: DimensionsResources.D_10.h),

            Text(
              DateFormat.yMMMMd().format(order.date),
              style: textTheme.headlineLarge?.copyWith(
                fontSize: DimensionsResources.FONT_SIZE_EXTRA_LARGE.sp,
              ),
            ),

            SizedBox(height: DimensionsResources.D_15.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: DimensionsResources.D_14.h),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(DimensionsResources.D_0_2),
                borderRadius: BorderRadius.circular(DimensionsResources.D_12.r),
              ),
              child: Center(
                child: Text(
                  StringResources.showDeliveryDetails,
                  style: textTheme.bodyLarge,
                ),
              ),
            ),

            SizedBox(height: DimensionsResources.D_15.h),

            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(DimensionsResources.D_0_1),
                borderRadius: BorderRadius.circular(DimensionsResources.D_12.r),
              ),
              child: Column(
                children: order.items.map((item) {
                  return ListTile(
                    leading: Container(
                      width: DimensionsResources.D_50.w,
                      height: DimensionsResources.D_50.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(DimensionsResources.D_8.r),
                      ),
                    ),
                    title: Text(item.name, style: textTheme.bodyLarge),
                    subtitle: Text(item.weight ?? '', style: textTheme.bodySmall),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.remove_circle, color: AppColors.grey, size: DimensionsResources.D_24.r),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_8.w),
                          child: Text(item.quantity.toString(), style: textTheme.bodyMedium),
                        ),
                        Icon(Icons.add_circle, color: AppColors.primary, size: DimensionsResources.D_24.r),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: DimensionsResources.D_20.h),

            Text(StringResources.deliveryMan, style: textTheme.bodyLarge),
            SizedBox(height: DimensionsResources.D_10.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(backgroundColor: AppColors.itemBackground),
              title: const Text("Brandon Henry"),
              subtitle: const Text("0331 999 666"),
            ),

            SizedBox(height: DimensionsResources.D_20.h),

            Text(StringResources.deliveryLocation, style: textTheme.bodyLarge),
            SizedBox(height: DimensionsResources.D_10.h),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.location_on, color: AppColors.primary),
              title: Text(order.address.address, style: textTheme.bodyMedium),
            ),

            const Divider(color: AppColors.border),

            _billRow(StringResources.subTotal, order.total - 50, textTheme),
            _billRow(StringResources.deliveryFee, 50, textTheme),
            _billRow(StringResources.promoCode, 0, textTheme),
            _billRow(StringResources.totalCost, order.total, textTheme, isBold: true),

            SizedBox(height: DimensionsResources.D_20.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(StringResources.ratingReview, style: textTheme.bodyLarge),
                InkWell(
                  onTap: (){
                   Navigator.pushNamed(context, AppRoutes.review);
                  },

                    child: Text(StringResources.viewAll, style: textTheme.labelLarge?.copyWith(color: AppColors.primary))),
              ],
            ),
            SizedBox(height: DimensionsResources.D_10.h),
            Row(
              children: [
                Text(
                  "4.5",
                  style: textTheme.displayLarge?.copyWith(fontSize: DimensionsResources.FONT_SIZE_LARGE.sp),
                ),
                SizedBox(width: DimensionsResources.D_10.w),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      Icons.star,
                      color: AppColors.amber,
                      size: DimensionsResources.D_24.r,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: DimensionsResources.D_10.h),
            Text(StringResources.feedbackSubtitle, style: textTheme.bodySmall),

            // Extra spacing to ensure content isn't hidden by the fixed button
            SizedBox(height: DimensionsResources.D_10.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_16.w,vertical: DimensionsResources.D_60.w ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: DimensionsResources.D_1)),
        ),
        child: CustomButton(
          onClick: () {
            // 1. Sync Cart with old items
            context.read<GroceryDetailBloc>().add(ReorderItemsEvent(order.items));
            
            // 2. Sync Address
            context.read<AddressBloc>().add(SelectAddressEvent(order.address));

            // 3. Navigate with persisted payment method
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CheckoutSummaryScreen(selectedMethod: order.paymentMethod),
              ),
            );
          },
          text: StringResources.reorderItem,
          textColor: AppColors.white,
        ),
      ),
    );
  }

  Widget _billRow(String title, double value, TextTheme textTheme, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DimensionsResources.D_4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isBold ? textTheme.titleLarge : textTheme.bodyMedium,
          ),
          Text(
            value.toStringAsFixed(0),
            style: isBold ? textTheme.titleLarge : textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
