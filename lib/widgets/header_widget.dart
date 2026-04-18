import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';

import '../core/helper/constants/dimensions-resource.dart';
import '../core/helper/constants/images-resources.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DimensionsResources.D_160.h,
      padding: EdgeInsets.only(top: DimensionsResources.D_50.h, left: DimensionsResources.D_16.w, right: DimensionsResources.D_16.w),
      decoration: const BoxDecoration(
        color: Color(0xFF1565C0),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(DimensionsResources.D_30),
          bottomRight: Radius.circular(DimensionsResources.D_30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [

                  Container(
                      width: DimensionsResources.D_40.r, // Double the radius for the total width
                      height: DimensionsResources.D_40.r,
                      decoration: BoxDecoration(
                        color: Colors.grey, // Fallback background
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(ImageResource.COMPANY_LOGO),
                          fit: BoxFit.cover, // Now you can use fit!
                        ),
                      ),
                    ),
                  SizedBox(width: DimensionsResources.D_12.w),
                  Text(
                    StringResources.omnigo,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: DimensionsResources.D_20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Icon(Icons.notifications, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}
