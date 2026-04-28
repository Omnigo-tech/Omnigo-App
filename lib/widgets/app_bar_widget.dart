import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/dimensions-resource.dart';
import '../core/helper/constants/images-resources.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.actions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: showBackButton
          ? IconButton(
        onPressed: onTap ??
                () {
              Navigator.pop(context);
            },
        icon:  SvgPicture.asset(
          ImageResource.BACK_ICON,
          width: DimensionsResources.D_30.w,
          height: DimensionsResources.D_30.h,
          colorFilter: ColorFilter.mode(
            AppColors.darkSecondary,
            BlendMode.srcIn,
          ),
        ),
      )
          : null,
      title: title != null
          ? Text(
        title!,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      )
          : null,
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}