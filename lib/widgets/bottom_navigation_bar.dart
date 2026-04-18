import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';

import '../core/helper/constants/dimensions-resource.dart';
import '../core/helper/constants/images-resources.dart';
import '../core/helper/constants/strings-resource.dart';

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({super.key});

  @override
  State<AppBottomBar> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  @override
  Widget build(BuildContext context) {
   return BottomNavigationBar(
     backgroundColor: AppColors.white,
     currentIndex: 0,
     type: BottomNavigationBarType.fixed,

     selectedItemColor: AppColors.primary,
     unselectedItemColor: AppColors.black,

     selectedLabelStyle: GoogleFonts.inter(
       fontSize: 12,
       fontWeight: FontWeight.w700,
       color: AppColors.primary,
     ),
     unselectedLabelStyle: GoogleFonts.inter(
       fontSize: 12,
       fontWeight: FontWeight.w700,
       color: AppColors.black,
     ),

     items: [
       BottomNavigationBarItem(
         icon: SvgPicture.asset(
           ImageResource.ICON_HOME,
           width: DimensionsResources.D_20.w,
           height: DimensionsResources.D_20.h,
         ),
         label: StringResources.home,
       ),
       BottomNavigationBarItem(
         icon: SvgPicture.asset(
           ImageResource.ICON_ORDER,
           width: DimensionsResources.D_20.w,
           height: DimensionsResources.D_20.h,
         ),
         label: StringResources.myOrder,
       ),
       BottomNavigationBarItem(
         icon: SvgPicture.asset(
           ImageResource.ICON_FAVOURITE,
           width: DimensionsResources.D_20.w,
           height: DimensionsResources.D_20.h,
         ),
         label: StringResources.favourite,
       ),
       BottomNavigationBarItem(
         icon: SvgPicture.asset(
           ImageResource.ICON_USER,
           width: DimensionsResources.D_30.w,
           height: DimensionsResources.D_30.h,
         ),
         label: StringResources.account,
       ),
     ],
   );
  }
}
