import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';
import 'package:grocery_app/presentation/bloc/home/home_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/grocery_home_screen.dart';

import '../core/helper/constants/dimensions-resource.dart';

class CategoriesWidget extends StatefulWidget {
  List<Map<String, String>> categories;
  CategoriesWidget({super.key, required this.categories});

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
              Text(
                StringResources.categories,
                style: GoogleFonts.quicksand(
                  fontSize: DimensionsResources.D_17.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                StringResources.seeAll,
                style: GoogleFonts.inter(
                  fontSize: DimensionsResources.D_13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: DimensionsResources.D_10.h),
          SizedBox(
            height: DimensionsResources.D_72.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              itemBuilder: (_, i) {
                final item = widget.categories[i];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return GroceryHomeScreen();
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: DimensionsResources.D_90.w,
                    height: DimensionsResources.D_72.h,
                    margin: EdgeInsets.only(right: DimensionsResources.D_10.w),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        DimensionsResources.D_14.r,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          item['image']!,
                          height: DimensionsResources.D_40.h,
                        ),
                        SizedBox(height: DimensionsResources.D_5.h),
                        Text(
                          item['title']!,
                          style: GoogleFonts.inter(
                            fontSize: DimensionsResources.D_11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
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
