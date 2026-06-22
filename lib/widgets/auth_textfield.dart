import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/helper/constants/colors_resources.dart';

class AuthTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final bool obscure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final String? prefixText;

  const AuthTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.obscure = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.prefixText,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: GoogleFonts.dmSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.darkPrimaryText,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          validator: widget.validator,
          style: GoogleFonts.dmSans(fontSize: 15.sp, color: AppColors.black),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            fillColor: AppColors.fieldBg,
            filled: true,
            hintText: widget.hint,
            hintStyle: GoogleFonts.dmSans(
              color: AppColors.grey,
              fontSize: 14.sp,
            ),
            prefixIcon: widget.prefixIcon,
            prefixText: widget.prefixText,
            prefixStyle: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            suffixIcon: widget.obscure
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.black,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : (widget.suffixIcon != null
                      ? Icon(
                          widget.suffixIcon,
                          color: AppColors.grey,
                          size: 20.sp,
                        )
                      : null),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(color: AppColors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(color: AppColors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(color: AppColors.red, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
