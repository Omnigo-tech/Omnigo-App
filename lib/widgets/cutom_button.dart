import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';

import '../core/helper/constants/dimensions-resource.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final String? isIcon;
  final Function()? onClick;
  final double? borderRadius;
  final Color? color;
  final Color? textColor;
  final TextStyle? fontStyle;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? minimumBtnWidth;
  final double? maximumBtnWidth;
  final double? minBtnHeight;
  final double? maxBtnHeight;
  final String? fontFamily;
  final Function()? onclickCal;
  final Widget? textWidget;
  final bool isLoading;

  const CustomButton({
    super.key,
    this.onclickCal,
    this.text,
    required this.onClick,
    this.isIcon,
    this.borderRadius,
    this.color,
    this.borderColor,
    this.fontStyle,
    this.textColor,
    this.minBtnHeight,
    this.maxBtnHeight,
    this.fontWeight,
    this.fontFamily,
    this.minimumBtnWidth,
    this.maximumBtnWidth,
    this.fontSize,
    this.textWidget,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: minimumBtnWidth ?? DimensionsResources.D_343.w,
      height: minBtnHeight ?? DimensionsResources.D_50.h,
      child: RawMaterialButton(
        onPressed: isLoading ? null : onClick,
        fillColor: color ?? AppColors.homeBackground,
        elevation: DimensionsResources.D_0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? DimensionsResources.FONT_SIZE_1X_EXTRA_SMALL,
          ),
          side: BorderSide(
            width: DimensionsResources.D_1.w,
            color: borderColor ?? AppColors.homeBackground,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (!isLoading && isIcon != null) ...[
              InkWell(
                onTap: onclickCal,
                child: SvgPicture.asset(
                  isIcon!,
                  height: DimensionsResources.D_20.h,
                  width: DimensionsResources.D_20.w,
                  colorFilter: ColorFilter.mode(
                    AppColors.homeBackground,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(width: DimensionsResources.D_6.w),
            ],
            Flexible(
              child:
              textWidget ??
                  Text(
                    text ?? "",
                    overflow: TextOverflow.ellipsis,
                    style:
                    fontStyle ??
                        TextStyle(
                          color: textColor ?? AppColors.homeBackground,
                          fontSize:
                          fontSize ??
                              DimensionsResources.FONT_SIZE_MEDIUM.r,
                          fontWeight: fontWeight ?? FontWeight.w600,
                        ),
                  ),
            ),
            if (isLoading) ...[
              SizedBox(width: DimensionsResources.D_8.w),
              SizedBox(
                width: DimensionsResources.D_20.w,
                height: DimensionsResources.D_20.h,
                child: CircularProgressIndicator(
                  strokeWidth: DimensionsResources.D_2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? AppColors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
