import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/widgets/cutom_button.dart';

import '../../../../widgets/app_bar_widget.dart';

class PaymentMethodScreen extends StatefulWidget {
  final double totalCost;

  const PaymentMethodScreen({super.key, required this.totalCost});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedMethod = 'COD';

  void _showWalletDetailsPopup(String walletName) {
    final TextEditingController accountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DimensionsResources.RADIUS_EXTRA_LARGE.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(DimensionsResources.D_20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      walletName,
                      style: GoogleFonts.dmSans(
                        fontSize: DimensionsResources.FONT_SIZE_LARGE.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                SizedBox(height: DimensionsResources.D_10.h),
                Text(
                  "Enter your $walletName account number to link for payments.",
                  style: GoogleFonts.dmSans(
                    fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                    color: AppColors.grey,
                  ),
                ),
                SizedBox(height: DimensionsResources.D_20.h),
                TextField(
                  controller: accountController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Account Number",
                    hintText: "03xx xxxxxxx",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(DimensionsResources.RADIUS_DEFAULT.r),
                    ),
                  ),
                ),
                SizedBox(height: DimensionsResources.D_24.h),
                CustomButton(
                  onClick: () {

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$walletName linked successfully!")),
                    );
                  },
                  text: "Link Account",
                  textColor: AppColors.white,
                  borderRadius: DimensionsResources.D_12.r,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar:CustomAppBar(
        title: StringResources.paymentMethod,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(DimensionsResources.D_20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    StringResources.cash,
                    style: GoogleFonts.dmSans(
                      fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: DimensionsResources.D_12.h),
                  _buildPaymentOption(
                    id: 'COD',
                    title: StringResources.cod,
                    subtitle: StringResources.codSubtitle,
                    icon: Icons.money,
                    iconColor: Colors.brown,
                  ),
                  SizedBox(height: DimensionsResources.D_24.h),
                  Text(
                    StringResources.mobileWallets,
                    style: GoogleFonts.dmSans(
                      fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: DimensionsResources.D_12.h),
                  _buildPaymentOption(
                    id: 'JazzCash',
                    title: StringResources.jazzCashWallet,
                    icon: Icons.account_balance_wallet,
                    iconColor: Colors.orange,
                  ),
                  _buildPaymentOption(
                    id: 'EasyPaisa',
                    title: StringResources.easyPaisaWallet,
                    icon: Icons.account_balance_wallet,
                    iconColor: Colors.green,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: DimensionsResources.D_60.h),
            child: CustomButton(
              onClick: () {

              },
              text: StringResources.confirmAndContinue,
              textColor: AppColors.white,
              borderRadius: DimensionsResources.D_19.r,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    String? subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    bool isSelected = selectedMethod == id;
    return GestureDetector(
      onTap: () {
        setState(() => selectedMethod = id);
        if (id == 'JazzCash' || id == 'EasyPaisa') {
          _showWalletDetailsPopup(title);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: DimensionsResources.D_12.h),
        padding: EdgeInsets.all(DimensionsResources.D_16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(DimensionsResources.RADIUS_DEFAULT.r),
          border: Border.all(
            color: isSelected ? Colors.blue : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30.sp, color: iconColor),
            SizedBox(width: DimensionsResources.D_16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.dmSans(
                        fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                        color: AppColors.grey,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }
}
