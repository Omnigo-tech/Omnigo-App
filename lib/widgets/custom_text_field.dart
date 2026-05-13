import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';

class PaymentInputField extends StatelessWidget {
  final String hint;
  final Function(String) onChanged;
  final Widget? suffixIcon;
  final bool isObscure;
  final String? Function(String?)? validator;

  const PaymentInputField({
    required this.hint,
    required this.onChanged,
    this.suffixIcon,
    this.isObscure = false,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_20.w, vertical: DimensionsResources.D_8.h),
      child: TextFormField(
        onChanged: onChanged,
        obscureText: isObscure,
        style: Theme.of(context).textTheme.bodyLarge,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context)
              .textTheme
              .labelSmall
              ?.copyWith(
              color: AppColors.grey,
              fontSize:DimensionsResources.D_14.w,
            ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.fieldBg,
          errorStyle: TextStyle(fontSize: DimensionsResources.D_12.sp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DimensionsResources.FONT_SIZE_1X_EXTRA_SMALL.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}