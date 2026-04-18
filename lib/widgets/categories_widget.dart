import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';

import '../core/helper/constants/dimensions-resource.dart';

class CategoriesWidget extends StatefulWidget {
   List<Map<String, String>> categories;
   CategoriesWidget({super.key,
   required this.categories
  });

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DimensionsResources.D_15.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(StringResources.categories, style: TextStyle(fontSize: DimensionsResources.D_16.sp)),
              Text(StringResources.seeAll, style: TextStyle(fontSize: DimensionsResources.D_14.sp)),
            ],
          ),
          SizedBox(height: DimensionsResources.D_10.h),
          SizedBox(
            height: DimensionsResources.D_90.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              itemBuilder: (_, i) {
                final item = widget.categories[i];

                return Container(
                  width: DimensionsResources.D_90.w,
                  margin: EdgeInsets.only(right: DimensionsResources.D_10.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DimensionsResources.D_14.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(item['image']!, height: DimensionsResources.D_40.h),
                      SizedBox(height: DimensionsResources.D_5.h),
                      Text(item['title']!, style: TextStyle(fontSize: DimensionsResources.D_12.sp)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
