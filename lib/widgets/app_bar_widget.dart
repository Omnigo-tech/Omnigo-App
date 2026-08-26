import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/dimensions-resource.dart';
import '../core/helper/constants/images-resources.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? customTitleWidget;
  final String? subTitle;
  final VoidCallback? onSubTitleTap;
  final Color? color;
  final Color? iconColor;
  final bool showBackButton;
  final VoidCallback? onTap;
  final List<Widget>? actions;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool centerTitle;

  /// Custom TextStyle Parameters
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  /// Custom Title Padding / Margin (Title ko aage/peeche karne ke liye)
  final EdgeInsetsGeometry? titlePadding;

  /// Bottom Section (TabBar / SearchBar ke liye)
  final PreferredSizeWidget? bottom;
  final double bottomHeight;

  const CustomAppBar({
    super.key,
    this.title,
    this.customTitleWidget,
    this.subTitle,
    this.onSubTitleTap,
    this.showBackButton = true,
    this.actions,
    this.onTap,
    this.color,
    this.iconColor,
    this.prefixIcon,
    this.suffixIcon,
    this.centerTitle = false,
    this.titleStyle,
    this.subTitleStyle,
    this.titlePadding,
    this.bottom,
    this.bottomHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,

      // Default spacing remove ki hai jab centerTitle false ho taaki back button ke sath jude
      titleSpacing: centerTitle ? null : (showBackButton ? 0 : NavigationToolbar.kMiddleSpacing),
      leading: showBackButton
          ? IconButton(
        onPressed: onTap ?? () => Navigator.pop(context),
        icon: SvgPicture.asset(
          ImageResource.BACK_ICON,
          width: DimensionsResources.D_30.w,
          height: DimensionsResources.D_30.h,
          colorFilter: ColorFilter.mode(
            iconColor ?? AppColors.darkSecondary,
            BlendMode.srcIn,
          ),
        ),
      )
          : null,

      /// Title Section
      title: Padding(
        padding: titlePadding ?? EdgeInsets.zero, // Custom margin / padding support
        child: customTitleWidget ??
            Row(
              mainAxisSize: centerTitle ? MainAxisSize.min : MainAxisSize.max,
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon!,
                  SizedBox(width: 8.w),
                ],
                if (title != null || subTitle != null)
                  Flexible(
                    child: Column(
                      crossAxisAlignment: centerTitle
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title Text
                        if (title != null)
                          Text(
                            title!,
                            overflow: TextOverflow.ellipsis,
                            style: titleStyle ??
                                theme.appBarTheme.titleTextStyle?.copyWith(
                                  color: color ?? AppColors.black,
                                ) ??
                                theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: color ?? AppColors.black,
                                ),
                          ),

                        // SubTitle Text
                        if (subTitle != null)
                          GestureDetector(
                            onTap: onSubTitleTap,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  subTitle!,
                                  style: subTitleStyle ??
                                      theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  size: 16.r,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                if (suffixIcon != null) ...[
                  SizedBox(width: 8.w),
                  suffixIcon!,
                ],
              ],
            ),
      ),

      centerTitle: centerTitle,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? bottomHeight));
}