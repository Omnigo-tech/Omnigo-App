import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/dimensions-resource.dart';
import '../core/helper/constants/images-resources.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? color;
  final Color? iconColor;

  final bool showBackButton;

  /// Back button tap
  final VoidCallback? onTap;

  /// Right side widgets
  final List<Widget>? actions;

  /// Prefix widget before title
  final Widget? prefixIcon;

  /// Suffix widget after title
  final Widget? suffixIcon;
  final bool? centerTitle;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.onTap,
    this.color,
    this.iconColor,
    this.prefixIcon,
    this.suffixIcon,
    this.centerTitle=true
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,

      /// Leading Back Button
      leading: showBackButton
          ? IconButton(
        onPressed: onTap ??
                () {
              Navigator.pop(context);
            },
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

      /// Custom Title Row
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Prefix Icon
          if (prefixIcon != null) ...[
            prefixIcon!,
            SizedBox(width: 8.w),
          ],

          /// Title
          if (title != null)
            Flexible(
              child: Text(
                title!,
                overflow: TextOverflow.ellipsis,
                style:
                Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                  color: color ?? AppColors.black,
                ),
              ),
            ),

          /// Suffix Icon
          if (suffixIcon != null) ...[
            SizedBox(width: 8.w),
            suffixIcon!,
          ],
        ],
      ),

      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}