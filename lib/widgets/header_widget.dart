import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/dimensions-resource.dart';
import '../core/helper/constants/images-resources.dart';
import '../core/helper/constants/strings-resource.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.homeBackground,
      elevation: DimensionsResources.D_0,
      automaticallyImplyLeading: false,

      title: Row(
        children: [
          Container(
            width: DimensionsResources.D_40.r,
            height: DimensionsResources.D_40.r,
            decoration: BoxDecoration(
              color: AppColors.grey,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(ImageResource.COMPANY_LOGO),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: DimensionsResources.D_8.w),

          Text(
            StringResources.omnigo,
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: DimensionsResources.FONT_SIZE_1X_EXTRA_MEDIUM.sp,
            ),
          ),
        ],
      ),

      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications_none,
            color: AppColors.white,
            size: DimensionsResources.D_24.sp,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
