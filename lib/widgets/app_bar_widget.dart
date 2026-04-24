import 'package:flutter/material.dart';
import '../../core/helper/constants/colors_resources.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    this.title,
    this.showBackButton = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,

      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => Navigator.pop(context),
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