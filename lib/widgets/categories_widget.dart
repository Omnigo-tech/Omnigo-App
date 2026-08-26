import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/helper/constants/colors_resources.dart';
import '../core/helper/constants/dimensions-resource.dart';
import '../core/helper/constants/strings-resource.dart';
import '../core/helper/utils/phone_formatter.dart';
import '../core/routes/AppRoutes.dart';
import '../data/models/grocery_category_model.dart';

class CategoriesWidget extends StatelessWidget {
  final List<GrocerySubCategoryModel> categories;

  const CategoriesWidget({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DimensionsResources.D_8.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
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
                    arguments: const GroceryHomeArgs(
                      showAll: true,
                    ),
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
            child: categories.isEmpty
                ? const Center(
              child: Text(
                "No categories available",
              ),
            )
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final category = categories[index];

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.groceryhome,
                      arguments: GroceryHomeArgs(
                        // Name pass karenge
                        category: category.name,
                      ),
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
                      borderRadius:
                      BorderRadius.circular(
                        DimensionsResources.D_14.r,
                      ),
                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: DimensionsResources.D_40.h,
                          width: DimensionsResources.D_40.h,
                          child: ClipRRect(
                            borderRadius:
                            BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:
                              ImageUrl.fixImageUrl(
                                category.image,
                              ),
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                              const Center(
                                child:
                                CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ),
                              ),
                              errorWidget: (_, __, ___) =>
                                  Icon(
                                    Icons.category_outlined,
                                    color: Colors.grey.shade400,
                                  ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: DimensionsResources.D_5.h,
                        ),

                        Text(
                          category.name,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize:
                            DimensionsResources.D_11.sp,
                            fontWeight:
                            FontWeight.w500,
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

class GroceryHomeArgs {
  final String? category;
  final bool showAll;

  const GroceryHomeArgs({
    this.category,
    this.showAll = false,
  });
}