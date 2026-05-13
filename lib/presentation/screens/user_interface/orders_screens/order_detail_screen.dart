import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/data/models/order_model.dart';
import 'package:grocery_app/widgets/cutom_button.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

  Color getStatusColor(String status) {
    switch (status) {
      case "pending":
        return Colors.orange;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return AppColors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyshade100,
      appBar: AppBar(title: Text("Order #${order.id}"), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DimensionsResources.D_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// STATUS + TIME
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.status == "delivered"
                      ? "Delivery Completed"
                      : "Order ${order.status}",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Text("6:30 pm", style: TextStyle(color: Colors.blue)),
              ],
            ),

            SizedBox(height: DimensionsResources.D_10.h),

            /// DATE
            Text(
              DateFormat.yMMMMd().format(order.date),
              style: const TextStyle(
                fontSize: DimensionsResources.FONT_SIZE_EXTRA_LARGE,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: DimensionsResources.D_15.h),

            /// BUTTON
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: DimensionsResources.D_14.sp,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.2),
                borderRadius: BorderRadius.circular(DimensionsResources.D_12.r),
              ),
              child: const Center(child: Text("Show Delivery Details")),
            ),

            SizedBox(height: DimensionsResources.D_15.h),

            /// ITEMS
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(.15),
                borderRadius: BorderRadius.circular(DimensionsResources.D_12.r),
              ),
              child: Column(
                children: order.items.map((item) {
                  return ListTile(
                    leading: Container(
                      width: DimensionsResources.D_50.w,
                      height: DimensionsResources.D_50.h,
                      color: AppColors.greyshade100,
                    ),
                    title: Text(item.name),
                    subtitle: Text(item.weight ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.remove_circle),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(item.quantity.toString()),
                        ),
                        const Icon(Icons.add_circle),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: DimensionsResources.D_20.h),

            /// DELIVERY MAN
            const Text(
              "Delivery Man",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: DimensionsResources.D_10.h),
            ListTile(
              leading: const CircleAvatar(),
              title: const Text("Brandon Henry"),
              subtitle: const Text("0331 999 666"),
            ),

            SizedBox(height: DimensionsResources.D_20.h),

            /// LOCATION
            const Text(
              "Delivery Location",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: DimensionsResources.D_10.h),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(order.address.address),
            ),

            const Divider(),

            /// BILL
            _billRow(StringResources.subTotal, order.total - 50),
            _billRow(StringResources.deliveryFee, 50),
            _billRow("Promo code", 0),
            _billRow(StringResources.total, order.total, isBold: true),

            SizedBox(height: DimensionsResources.D_20.h),

            /// RATING
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rating & Review",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("view all", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: DimensionsResources.D_10.h),
            Row(
              children: [
                Text(
                  "4.5",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: DimensionsResources.FONT_SIZE_LARGE,
                  ),
                ),
                SizedBox(width: DimensionsResources.D_10.w),
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star,
                      color: AppColors.amber,
                      size: DimensionsResources.D_30,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: DimensionsResources.D_10.h),

            const Text(StringResources.ratingInfo),

            SizedBox(height: DimensionsResources.D_20.h),

            /// BUTTON
            CustomButton(
              onClick: () {},
              text: "Reorder Item",
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _billRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value.toStringAsFixed(0),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
