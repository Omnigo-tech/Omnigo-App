import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_event.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_state.dart';
import 'package:grocery_app/widgets/checkout_bottom_sheet.dart';
import 'package:grocery_app/widgets/cutom_button.dart';
import '../../../../widgets/circle_button_widget.dart';

class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  void _showCheckoutBottomSheet(BuildContext context, double totalCost) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<GroceryDetailBloc>(),
        child: CheckoutBottomSheet(
          totalCost: totalCost,
          onPlaceOrder: () {
            context.read<GroceryDetailBloc>().add(PlaceOrderEvent());
            Navigator.pop(context); // Close BottomSheet
            _showOrderSuccessDialog(context);
          },
        ),
      ),
    );
  }

  void _showOrderSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green, size: 80.sp),
            SizedBox(height: 20.h),
            Text(
              StringResources.orderPlacedSuccess,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            CustomButton(
              onClick: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              text: "Back to Home",
              textColor: AppColors.white,
              borderRadius: 12.r,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          StringResources.myCart,
          style: GoogleFonts.dmSans(
            color: AppColors.black,
            fontSize: DimensionsResources.FONT_SIZE_2X_EXTRA_MEDIUM.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: AppColors.border,
            height: 1.0,
          ),
        ),
      ),
      body: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
        builder: (context, state) {
          final cartList = state.cart;

          if (cartList.isEmpty) {
            return Center(
              child: Text(
                StringResources.cartEmpty,
                style: GoogleFonts.dmSans(fontSize: 18.sp),
              ),
            );
          }

          double totalCost = 0;
          for (var item in cartList) {
            totalCost += (item.price * item.quantity);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  itemCount: cartList.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.border,
                    thickness: 1,
                    indent: 16.w,
                    endIndent: 16.w,
                  ),
                  itemBuilder: (context, index) {
                    final item = cartList[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Image.asset(
                            item.image,
                            width: 70.w,
                            height: 70.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.name,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.read<GroceryDetailBloc>().add(
                                            RemoveFromCartEvent(item.id));
                                      },
                                      child: const Icon(Icons.close, color: AppColors.grey),
                                    ),
                                  ],
                                ),
                                Text(
                                  "${item.weight ?? ''}, Price",
                                  style: GoogleFonts.dmSans(
                                    fontSize: 14.sp,
                                    color: AppColors.lightText,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CustomCircleBtn(
                                          icon: Icons.remove,
                                          isAdd: false,
                                          size: 40,
                                          borderRadius: 14,
                                          onTap: () {
                                            context.read<GroceryDetailBloc>().add(
                                                DecrementQtyEvent(item.id));
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                                          child: Text(
                                            item.quantity.toString(),
                                            style: GoogleFonts.dmSans(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        CustomCircleBtn(
                                          icon: Icons.add,
                                          isAdd: true,
                                          size: 40,
                                          borderRadius: 14,
                                          onTap: () {
                                            context.read<GroceryDetailBloc>().add(
                                                IncrementQtyEvent(item.id));
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "\$${(item.price * item.quantity).toStringAsFixed(2)}",
                                      style: GoogleFonts.dmSans(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: CustomButton(
                    onClick: () => _showCheckoutBottomSheet(context, totalCost),
                    text: StringResources.goToCheckout,
                    textColor: AppColors.white,
                    borderRadius: 19.r,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
