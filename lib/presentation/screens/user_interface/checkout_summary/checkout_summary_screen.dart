import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_event.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_state.dart';
import 'package:grocery_app/presentation/screens/user_interface/address_list/address_screen.dart';
import 'package:grocery_app/widgets/circle_button_widget.dart';
import 'package:grocery_app/widgets/cutom_button.dart';

class CheckoutSummaryScreen extends StatelessWidget {
  const CheckoutSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          "Checkout Summary",
          style: GoogleFonts.dmSans(
            fontSize: DimensionsResources.D_18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),

      body: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
        builder: (context, state) {
          final cartList = state.cart;

          double subtotal = 0;
          for (var item in cartList) {
            subtotal += item.price * item.quantity;
          }

          final deliveryFee = 6.0;
          final tax = 2.5;
          final total = subtotal + deliveryFee + tax;

          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery Address",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        BlocBuilder<AddressBloc, AddressState>(
                          builder: (context, state) {
                            final address = state.selectedAddress;

                            return Container(
                              padding: EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.grey),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address?.locationname ??
                                              "Select Address",
                                          style: TextStyle(fontWeight: .bold),
                                        ),
                                        Text(address?.address ?? ""),
                                      ],
                                    ),
                                  ),

                                  IconButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<AddressBloc>(),
                                          child: const AddressListScreen(),
                                        ),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),
                        Center(
                          child: GestureDetector(
                            onTap: () {},
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 18.r,
                                  backgroundColor: AppColors.border,
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.white,
                                  ),
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  "Add new address",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          "Products in Cart",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cartList.length,
                            separatorBuilder: (_, _) =>
                                Divider(color: AppColors.border),
                            itemBuilder: (context, index) {
                              final item = cartList[index];

                              return Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 60.w,
                                      height: 60.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.itemBackground,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10.w),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: GoogleFonts.dmSans(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            item.weight ?? '',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                            "\$${item.price}",
                                            style: GoogleFonts.dmSans(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        CustomCircleBtn(
                                          icon: Icons.remove,
                                          isAdd: false,
                                          size: 30,
                                          borderRadius: 10,
                                          onTap: () {
                                            context
                                                .read<GroceryDetailBloc>()
                                                .add(
                                                  DecrementQtyEvent(item.id),
                                                );
                                          },
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(item.quantity.toString()),
                                        SizedBox(width: 8.w),
                                        CustomCircleBtn(
                                          icon: Icons.add,
                                          isAdd: true,
                                          size: 30,
                                          borderRadius: 10,
                                          onTap: () {
                                            context
                                                .read<GroceryDetailBloc>()
                                                .add(
                                                  IncrementQtyEvent(item.id),
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Text(
                          "Bill Details",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            children: [
                              _billRow("Subtotal", subtotal),
                              _billRow("Delivery Fee", deliveryFee),
                              _billRow("Tax & Other Fees", tax),
                              Divider(),
                              _billRow("Total", total, isBold: true),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                height: 45,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text("Add Promo"),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.homeBackground,
                              ),
                              child: Text("Apply"),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(DimensionsResources.D_16.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: DimensionsResources.D_50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.homeBackground,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext dialogContext) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  DimensionsResources.RADIUS_EXTRA_LARGE.r,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  DimensionsResources.D_20.w,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: AppColors.darkGreen,
                                      size: DimensionsResources.D_80.sp,
                                    ),
                                    SizedBox(
                                      height: DimensionsResources.D_20.h,
                                    ),
                                    Text(
                                      "Order Confirmed",
                                      style: GoogleFonts.dmSans(
                                        fontSize: DimensionsResources
                                            .FONT_SIZE_LARGE
                                            .sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: DimensionsResources.D_10.h,
                                    ),
                                    Text(
                                      "Your order has been placed successfully.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.dmSans(
                                        fontSize: DimensionsResources
                                            .FONT_SIZE_MEDIUM
                                            .sp,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                      height: DimensionsResources.D_24.h,
                                    ),
                                    CustomButton(
                                      onClick: () {
                                        Navigator.pop(dialogContext);
                                      },
                                      text: "Done",
                                      textColor: AppColors.white,
                                      borderRadius: DimensionsResources.D_12.r,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text("Confirm Your Order"),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _billRow(String title, double value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
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
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
