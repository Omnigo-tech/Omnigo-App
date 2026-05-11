import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_event.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_state.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/grocery_home_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/address_list/add_address_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/address_list/address_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/review/review_screen.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';
import 'package:grocery_app/widgets/circle_button_widget.dart';
import 'package:grocery_app/widgets/cutom_button.dart';
import '../../../../core/helper/constants/strings-resource.dart';
import '../../../../core/helper/utils/dialogs/show_cart_dialog.dart';

import '../../../../widgets/app_bar_widget.dart';
import '../../../../widgets/auth_button.dart';
import '../../../../widgets/circle_button_widget.dart';
import '../../../../widgets/confirm_order.dart';

class CheckoutSummaryScreen extends StatefulWidget {
  String? selectedMethod;
   CheckoutSummaryScreen({super.key,
  required this.selectedMethod
  });

  @override
  State<CheckoutSummaryScreen> createState() => _CheckoutSummaryScreenState();
}

class _CheckoutSummaryScreenState extends State<CheckoutSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: CustomAppBar(
        title: StringResources.checkoutSummary,
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<AddressBloc>(),
                                    child: const AddAddressScreen(),
                                  ),
                                ),
                              );
                            },
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
                        SizedBox(height: 15.h),
                        Text(
                          "Payment Method",
                          style: GoogleFonts.dmSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: SizedBox(
                            height: 60.h,
                            width: 160.w,
                            child: Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                             child: Text("${widget.selectedMethod}",
                             textAlign: TextAlign.center,
                               maxLines: 2,
                               overflow: TextOverflow.ellipsis,
                               style: GoogleFonts.dmSans(
                                   fontWeight: FontWeight.bold,
                                 ),
                             ),
                            ),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReviewScreen(),
                                  ),
                                );
                              },
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmOrder(),
                          ),
                        );
                        //_orderFail(context);
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

  void _orderFail(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Align(
            alignment: AlignmentGeometry.topLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.cancel_rounded, color: AppColors.lightText),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: DimensionsResources.D_20),
              SizedBox(
                height: DimensionsResources.D_150.h,
                child: Image.asset(
                  ImageResource.FAIL_ORDER,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: DimensionsResources.D_40),
              Text(
                StringResources.orderFail,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: DimensionsResources.FONT_SIZE_LARGE,
                ),
              ),
              SizedBox(height: DimensionsResources.D_50),
              AuthButton(
                text: StringResources.tryAgain,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: DimensionsResources.D_20),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GroceryHomeScreen(nameCategories: "",)),
                ),
                child: Text(
                  StringResources.backToHome,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
