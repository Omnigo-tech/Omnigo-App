import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:grocery_app/core/helper/constants/colors_resources.dart';

import '../../data/models/fast_foods_models/fast_food_category_model.dart';

class CategoryItem extends StatelessWidget {

  final SubCategoryModel item;

  final bool isSelected;

  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,

      child: SizedBox(
        width: 88.w,
        height: 90.h,

        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,

          children: [

            if (isSelected) ...[

              Positioned(
                left: -16.w,
                bottom: 0,

                child: Container(
                  width: 16.w,
                  height: 16.w,
                  color: Colors.white,

                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,

                      borderRadius:
                      BorderRadius.only(
                        bottomRight:
                        Radius.circular(20.r),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                right: -16.w,
                bottom: 0,

                child: Container(
                  width: 16.w,
                  height: 16.w,
                  color: Colors.white,

                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,

                      borderRadius:
                      BorderRadius.only(
                        bottomLeft:
                        Radius.circular(20.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],

            AnimatedContainer(
              duration:
              const Duration(milliseconds: 250),

              curve: Curves.easeInOut,

              width: isSelected
                  ? 88.w
                  : 80.w,

              height: 80.h,

              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.transparent,

                borderRadius: isSelected
                    ? BorderRadius.vertical(
                  top:
                  Radius.circular(44.r),
                  bottom:
                  Radius.zero,
                )
                    : BorderRadius.zero,
              ),

              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  SizedBox(
                    height:
                    isSelected ? 4.h : 0,
                  ),

                  AnimatedContainer(
                    duration:
                    const Duration(
                        milliseconds: 250),

                    curve: Curves.easeInOut,

                    width: isSelected
                        ? 58.w
                        : 53.w,

                    height: isSelected
                        ? 58.w
                        : 53.w,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,

                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(
                              0.04),
                          blurRadius: 6.r,
                          offset:
                          const Offset(
                              0, 2),
                        ),
                      ]
                          : null,
                    ),

                    child: ClipOval(
                      child: Padding(
                        padding:
                        EdgeInsets.all(3.r),

                        child: CachedNetworkImage(
                            imageUrl:item.image ?? '',
                          fit: BoxFit.cover,

                          errorWidget:
                              (context, error, stackTrace) {

                            return Icon(
                              Icons.fastfood,
                              color:
                              Colors.orange,
                              size: 28.r,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    item.name,

                    textAlign: TextAlign.center,

                    maxLines: 1,

                    overflow:
                    TextOverflow.ellipsis,

                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.sp,

                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,

                      color: isSelected
                          ? const Color(0xFF000000)
                          : const Color(0xFFFFFFFF),

                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}