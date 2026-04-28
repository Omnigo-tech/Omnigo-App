import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';
import 'package:grocery_app/presentation/screens/user_interface/checkout_summary/checkout_summary_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/payment_method_screen.dart';
import 'package:grocery_app/widgets/cutom_button.dart';

class CheckoutBottomSheet extends StatelessWidget {
  final double totalCost;
  final VoidCallback onPlaceOrder;

  const CheckoutBottomSheet({
    super.key,
    required this.totalCost,
    required this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(DimensionsResources.D_24.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DimensionsResources.D_30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringResources.checkout,
                style: GoogleFonts.dmSans(
                  fontSize: DimensionsResources.FONT_SIZE_EXTRA_LARGE.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: AppColors.black),
              ),
            ],
          ),
          const Divider(color: AppColors.border),
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                  context,
                  AppRoutes.paymentmethodScreen
              );
            },
            child: _buildCheckoutRow(
              title: StringResources.paymentMethod,
              trailing: Text(
                StringResources.selectMethod,
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          const Divider(color: AppColors.border),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckoutSummaryScreen(),
                ),
              );
            },
            child: _buildCheckoutRow(
              title: StringResources.checkoutSummary,
              trailing: Container(),
            ),
          ),
          const Divider(color: AppColors.border),
          _buildCheckoutRow(
            title: StringResources.totalCost,
            trailing: Text(
              "Rs. ${totalCost.toStringAsFixed(0)}",
              style: GoogleFonts.dmSans(
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
          ),
          const Divider(color: AppColors.border),
          SizedBox(height: DimensionsResources.D_20.h),
          RichText(
            text: TextSpan(
              text: StringResources.termsAndConditionsText,
              style: GoogleFonts.dmSans(
                color: AppColors.grey,
                fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
              ),
              children: [
                TextSpan(
                  text: StringResources.terms,
                  style: GoogleFonts.dmSans(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: StringResources.and),
                TextSpan(
                  text: StringResources.conditions,
                  style: GoogleFonts.dmSans(
                    color: AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: DimensionsResources.D_24.h),
          CustomButton(
            onClick: onPlaceOrder,
            text: StringResources.placeOrder,
            textColor: AppColors.white,
            borderRadius: DimensionsResources.D_19.r,
          ),
          SizedBox(height: DimensionsResources.D_40.h),
        ],
      ),
    );
  }

  Widget _buildCheckoutRow({required String title, required Widget trailing}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DimensionsResources.D_10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp,
              color: AppColors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              trailing,
              SizedBox(width: DimensionsResources.D_10.w),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.black),
            ],
          ),
        ],
      ),
    );
  }
}
