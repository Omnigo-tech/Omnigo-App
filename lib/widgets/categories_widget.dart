import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';

import '../core/helper/constants/dimensions-resource.dart';

class CategoriesWidget extends StatefulWidget {
  // Categories now come straight from GroceryState as a List<String>
  final List<String> categories;

  // Random product image per category, also from GroceryState
  final Map<String, String> categoryImages;

  const CategoriesWidget({
    super.key,
    required this.categories,
    required this.categoryImages,
  });

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  // Same localhost → real IP fix used elsewhere in the app
  String fixImageUrl(String url) {
    return url.replaceAll('localhost', '192.168.2.104');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DimensionsResources.D_8.w),
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
              InkWell(
                onTap: () {
                  // "See all" — unchanged behavior, still goes to
                  // grocery home with vegetables as before
                  Navigator.pushNamed(
                    context,
                    AppRoutes.groceryhome,
                    arguments:
                        widget.categories.first, //StringResources.vegetables,
                  );
                },
                child: Text(
                  StringResources.seeAll,
                  style: GoogleFonts.inter(
                    fontSize: DimensionsResources.D_13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DimensionsResources.D_20.h),
          SizedBox(
            height: DimensionsResources.D_72.h,
            child: widget.categories.isEmpty
                ? const Center(
                    child: Text(
                      "No categories available",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.categories.length,
                    itemBuilder: (_, i) {
                      final categoryName = widget.categories[i];
                      final imageUrl =
                          widget.categoryImages[categoryName] ?? "";

                      return InkWell(
                        onTap: () {
                          // Navigate to grocery home screen passing the
                          // tapped category — route generator dispatches
                          // LoadGroceryEvent(initialCategory: category) so
                          // it's selected as soon as products finish
                          // loading there.
                          Navigator.pushNamed(
                            context,
                            AppRoutes.groceryhome,
                            arguments: categoryName,
                          );
                        },
                        child: Container(
                          width: DimensionsResources.D_90.w,
                          height: DimensionsResources.D_72.h,
                          margin: EdgeInsets.only(
                            right: DimensionsResources.D_10.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              DimensionsResources.D_14.r,
                            ),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image now loaded from API (network)
                              // instead of a local asset
                              SizedBox(
                                height: DimensionsResources.D_40.h,
                                width: DimensionsResources.D_40.h,
                                child: imageUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          fixImageUrl(imageUrl),
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (context, child, progress) {
                                                if (progress == null) {
                                                  return child;
                                                }
                                                return const Center(
                                                  child: SizedBox(
                                                    width: 14,
                                                    height: 14,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 1.5,
                                                        ),
                                                  ),
                                                );
                                              },
                                          errorBuilder: (_, error, __) => Icon(
                                            Icons.broken_image_outlined,
                                            color: Colors.grey.shade400,
                                            size: 22,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        Icons.category_outlined,
                                        color: Colors.grey.shade400,
                                        size: 22,
                                      ),
                              ),
                              SizedBox(height: DimensionsResources.D_5.h),
                              Text(
                                categoryName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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

/*import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_bloc/grocery_event.dart';
import '../core/routes/AppRoutes.dart';

class CategoriesWidget extends StatefulWidget {
  // Categories now come straight from GroceryState as a List<String>
  final List<String> categories;

  // Random product image per category, also from GroceryState
  final Map<String, String> categoryImages;

  const CategoriesWidget({
    super.key,
    required this.categories,
    required this.categoryImages,
  });

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  // ✅ Same localhost → real IP fix used elsewhere in the app
  String fixImageUrl(String url) {
    return url.replaceAll('localhost', '192.168.2.104');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DimensionsResources.D_8.w),
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
              InkWell(
                onTap: () {
                  // "See all" still goes to grocery home with a default
                  // category — first available category instead of a
                  // hardcoded string
                  final defaultCategory = widget.categories.isNotEmpty
                      ? widget.categories.first
                      : StringResources.vegetables;
                  Navigator.pushNamed(
                    context,
                    AppRoutes.groceryhome,
                    arguments: defaultCategory,
                  );
                },
                child: Text(
                  StringResources.seeAll,
                  style: GoogleFonts.inter(
                    fontSize: DimensionsResources.D_13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DimensionsResources.D_20.h),
          SizedBox(
            height: DimensionsResources.D_72.h,
            child: widget.categories.isEmpty
                ? const Center(
                    child: Text(
                      "No categories available",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.categories.length,
                    itemBuilder: (_, i) {
                      final categoryName = widget.categories[i];
                      final imageUrl =
                          widget.categoryImages[categoryName] ?? "";

                      return InkWell(
                        onTap: () {
                          // Navigate to grocery home screen passing the
                          // tapped category — route generator dispatches
                          // LoadGroceryEvent(initialCategory: category) so
                          // it's selected as soon as products finish
                          // loading there (no race condition).
                          Navigator.pushNamed(
                            context,
                            AppRoutes.groceryhome,
                            arguments: categoryName,
                          );
                        },
                        child: Container(
                          width: DimensionsResources.D_90.w,
                          height: DimensionsResources.D_72.h,
                          margin: EdgeInsets.only(
                            right: DimensionsResources.D_10.w,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              DimensionsResources.D_14.r,
                            ),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image now loaded from API (network image)
                              // instead of a local asset
                              SizedBox(
                                height: DimensionsResources.D_40.h,
                                width: DimensionsResources.D_40.h,
                                child: imageUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          fixImageUrl(imageUrl),
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (context, child, progress) {
                                                if (progress == null) {
                                                  return child;
                                                }
                                                return const Center(
                                                  child: SizedBox(
                                                    width: 14,
                                                    height: 14,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 1.5,
                                                        ),
                                                  ),
                                                );
                                              },
                                          errorBuilder: (_, error, __) => Icon(
                                            Icons.broken_image_outlined,
                                            color: Colors.grey.shade400,
                                            size: 22,
                                          ),
                                        ),
                                      )
                                    : Icon(
                                        Icons.category_outlined,
                                        color: Colors.grey.shade400,
                                        size: 22,
                                      ),
                              ),
                              SizedBox(height: DimensionsResources.D_5.h),
                              Text(
                                categoryName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
}*/

//old & real
/*import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';

import '../core/helper/constants/dimensions-resource.dart';
import '../data/models/grocery-item.dart';

class CategoriesWidget extends StatefulWidget {
  List<GroceryItemModel> categories;
  CategoriesWidget({super.key, required this.categories});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DimensionsResources.D_8.w),
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
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.groceryhome,
                    arguments: StringResources.vegetables,
                  );
                },
                child: Text(
                  StringResources.seeAll,
                  style: GoogleFonts.inter(
                    fontSize: DimensionsResources.D_13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DimensionsResources.D_20.h),
          SizedBox(
            height: DimensionsResources.D_72.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              itemBuilder: (_, i) {
                final item = widget.categories[i];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.groceryhome,
                      arguments: item.name,
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
                          item.image,
                          height: DimensionsResources.D_40.h,
                        ),
                        SizedBox(height: DimensionsResources.D_5.h),
                        Text(
                          item.name,
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
}*/
