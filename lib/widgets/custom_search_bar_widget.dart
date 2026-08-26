import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final Color backgroundColor;
  final double? height;
  final EdgeInsetsGeometry? margin;

  // Customizable properties for Border & Shadow
  final Border? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool autofocus;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onTap,
    this.onFilterTap,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.backgroundColor = Colors.white,
    this.height,
    this.margin,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? BorderRadius.circular(22.r);

    // Build standard suffix widget and ensure onFilterTap works even if custom suffixIcon is passed
    Widget? effectiveSuffixIcon;
    if (suffixIcon != null || onFilterTap != null) {
      effectiveSuffixIcon = InkWell(
        onTap: onFilterTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.only(left: 8.w, right: 14.w),
          child: suffixIcon ??
              Icon(
                Icons.tune_rounded,
                size: 20.r,
                color: Colors.black87,
              ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: height ?? 43.h,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: effectiveRadius,
        border: border,
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10.r,
                offset: const Offset(0, 3),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: effectiveRadius,
        child: Row(
          children: [
            // Left Search Icon
            prefixIcon ??
                Padding(
                  padding: EdgeInsets.only(left: 14.w, right: 10.w),
                  child: Icon(
                    Icons.search,
                    size: 20.r,
                    color: Colors.black87,
                  ),
                ),

            // TextField Area (Tappable for Search Screen Navigation)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: AbsorbPointer(
                  absorbing: readOnly, // Prevents TextField from absorbing taps when readOnly
                  child: TextField(
                    controller: controller,
                    readOnly: readOnly,
                    autofocus: autofocus,
                    onChanged: onChanged,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontFamily: 'Inter',
                      height: 1.2,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: false,
                      fillColor: Colors.transparent,
                      hintText: hintText,
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black45,
                        fontFamily: 'Inter',
                        height: 1.2,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),

            // Filter Icon Area (Secluded Touch Region)
            if (effectiveSuffixIcon != null) effectiveSuffixIcon,
          ],
        ),
      ),
    );
  }
}