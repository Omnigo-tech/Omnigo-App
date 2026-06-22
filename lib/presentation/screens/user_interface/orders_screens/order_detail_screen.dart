import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_event.dart';
import 'package:intl/intl.dart';

import '../../../../core/helper/utils/phone_formatter.dart';
import '../../../../core/routes/AppRoutes.dart';
import '../../../../widgets/cutom_button.dart';
import '../../../bloc/grocery_details/item_detail_state.dart';
import '../checkout_summary/checkout_summary_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  final String orderNumber;

  const OrderDetailScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GroceryDetailBloc>().add(
        GetOrderDetailsEvent(widget.orderId),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          "${StringResources.orderDetail}${widget.orderNumber}",
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
        builder: (context, state) {
          if (state.isOrderDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final order = state.orderDetail;

          if (order == null) {
            return const Center(
              child: Text(
                "Order not found",
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppColors.white,
            body: SingleChildScrollView(
              padding: EdgeInsets.all(
                DimensionsResources.D_16.w,
              ),
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
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(
                          order.createdAt!.toLocal(),
                        ),
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: DimensionsResources.D_10.h,
                  ),

                  Text(
                    order.createdAt != null
                        ? DateFormat.yMMMMd().format(
                      order.createdAt!,
                    )
                        : '',
                    style: textTheme.headlineLarge?.copyWith(
                      fontSize: DimensionsResources.FONT_SIZE_EXTRA_LARGE.sp,
                    ),
                  ),

                  SizedBox(
                    height: DimensionsResources.D_20.h,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        DimensionsResources.D_12.r,
                      ),
                    ),
                    child: Column(
                      children: order.items.map((item) {
                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:  Image.network(
                              ImageUrl.fixImageUrl(item.image),
                              width: 50.w,
                              height: 50.h,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          ),
                          title: Text(
                            item.name,
                          ),
                          subtitle: Text(
                            item.weight ?? '',
                          ),
                          trailing: Text(
                            "x${item.quantity}",
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(
                    height: DimensionsResources.D_20.h,
                  ),

                  Text(
                    StringResources.deliveryMan,
                    style: textTheme.bodyLarge,
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.itemBackground,
                      child: Icon(
                        Icons.person,
                      ),
                    ),
                    title: Text(
                      order.rider?.name ?? "Rider not assigned",
                    ),
                    subtitle: Text(
                      order.rider?.phone ?? "N/A",
                    ),
                  ),

                  SizedBox(
                    height: DimensionsResources.D_20.h,
                  ),

                  Text(
                    StringResources.deliveryLocation,
                    style: textTheme.bodyLarge,
                  ),

                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      order.address?.address ?? "",
                    ),
                    subtitle: Text(
                      "${order.address?.city ?? ''}, ${order.address?.country ?? ''}",
                    ),
                  ),

                  const Divider(),

                  /// BILLING
                  _billRow(
                    StringResources.subTotal,
                    order.subtotal,
                    textTheme,
                  ),

                  _billRow(
                    StringResources.deliveryFee,
                    order.deliveryFee,
                    textTheme,
                  ),

                  _billRow(
                    StringResources.promoCode,
                    order.promoDiscount,
                    textTheme,
                  ),

                  _billRow(
                    StringResources.totalCost,
                    order.totalAmount,
                    textTheme,
                    isBold: true,
                  ),

                  SizedBox(
                    height: DimensionsResources.D_30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(StringResources.ratingReview, style: textTheme.bodyLarge),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.review);
                          },
                          child: Text(StringResources.viewAll,
                              style: textTheme.labelLarge?.copyWith(color: AppColors.primary))),
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
                  SizedBox(height: DimensionsResources.D_10.h),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: DimensionsResources.D_16.w, vertical: DimensionsResources.D_60.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(top: BorderSide(color: AppColors.border, width: DimensionsResources.D_1)),
              ),
              child: BlocConsumer<GroceryDetailBloc, GroceryDetailState>(
                listener: (context, state) {
                  if (state.message == "Reorder Success") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutSummaryScreen(selectedMethod: order.paymentMethod),
                      ),
                    );
                  } else if (state.message.isNotEmpty && state.message != "ReorderSuccess") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    onClick: state.isOrderLoading
                        ? null
                        : () {
                      context.read<GroceryDetailBloc>().add(
                        CallReorderApiEvent(widget.orderId),
                      );
                    },
                    text: "Reorder",
                    textColor: AppColors.white,
                    isLoading: state.isOrderLoading,
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _billRow(
      String title,
      double value,
      TextTheme textTheme, {
        bool isBold = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isBold ? textTheme.titleLarge : textTheme.bodyMedium,
          ),
          Text(
            "Rs ${value.toStringAsFixed(1)}",
            style: isBold ? textTheme.titleLarge : textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}