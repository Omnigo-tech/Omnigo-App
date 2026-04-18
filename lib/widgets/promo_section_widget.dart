import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';

import '../core/helper/constants/dimensions-resource.dart';

class PromoSection extends StatelessWidget {
  const PromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 320.h,
      decoration: BoxDecoration(
        color:AppColors.brandedBlue
      ),
      child: Padding(
        padding:  EdgeInsets.all(DimensionsResources.D_16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: DimensionsResources.D_120.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(DimensionsResources.D_18.r),
                        ),
                        child: const Center(child: Text('${StringResources.fastFood}')),
                      ),
                      SizedBox(height: DimensionsResources.D_10.h),
                      Container(
                        height: DimensionsResources.D_120.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(DimensionsResources.D_18.r),
                        ),
                        child:  Center(  child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, size: DimensionsResources.D_20.sp),
                            SizedBox(height: DimensionsResources.D_4.h),
                            Text(
                              StringResources.soon,
                              style: TextStyle(
                                fontSize: DimensionsResources.D_12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: DimensionsResources.D_10.w),
                Expanded(
                  child: Column(
                    children: [
                      _smallCard(),
                      SizedBox(height: DimensionsResources.D_10.h),
                      _smallCard(),
                      SizedBox(height: DimensionsResources.D_10.h),
                      _smallCard(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallCard() {
    return Container(
      height: DimensionsResources.D_65.h,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(DimensionsResources.D_14.r),
      ),
      child:  Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.access_time, size: DimensionsResources.D_21.sp),
          SizedBox(height: DimensionsResources.D_4.h),
          Text(
            StringResources.soon,
            style: TextStyle(
              fontSize: DimensionsResources.D_12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),),
    );
  }
}