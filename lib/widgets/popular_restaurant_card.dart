import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopularRestaurantCard extends StatelessWidget {
  final String imageUrl;
  final String? logoUrl; // Added Logo Field
  final String title;
  final String subtitle;
  final String rating;
  final String deliveryFee;
  final String deliveryTime;
  final String? badgeText;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const PopularRestaurantCard({
    super.key,
    required this.imageUrl,
    this.logoUrl,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.deliveryFee,
    required this.deliveryTime,
    this.badgeText = 'Most popular',
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 239.w,
        height: 206.h,
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB), // CSS: background: #FBFBFB
          borderRadius: BorderRadius.circular(12.r), // CSS: border-radius: 12px
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. Top Banner Image + Badge + Favorite Icon Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12.r),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 118.h,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    placeholder: (context, url) {
                      return Container(
                        height: 118.h,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },

                    errorWidget: (context, url, error) {
                      return Container(
                        height: 118.h,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.restaurant,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                /// Most Popular Badge
                if (badgeText != null && badgeText!.isNotEmpty)
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E5BBA),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            size: 12.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            badgeText!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                /// Favorite Button
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: EdgeInsets.all(5.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 14.sp,
                        color: isFavorite ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// 2. Details Section (Logo + Title/Subtitle + Rating)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Restaurant Logo (Figma Dimensions: 27px x 27px)
                      Container(
                        width: 27.w,
                        height: 27.h,
                        margin: EdgeInsets.only(right: 8.w, top: 2.h),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: ClipOval(
                          child: logoUrl != null && logoUrl!.isNotEmpty
                              ? Image.asset(
                            logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.store,
                                    size: 16.r, color: Colors.grey),
                          )
                              : Icon(Icons.store,
                              size: 16.r, color: Colors.grey),
                        ),
                      ),

                      /// Title & Subtitle Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Title and Rating Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                      size: 15.sp,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      rating,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 1.h),

                            /// Subtitle / Category
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  /// Delivery Fee & Time Row (Left aligned with Logo)
                  Row(
                    children: [
                      SizedBox(width: 35.w), // Aligns under the title
                      Icon(
                        Icons.directions_bike_outlined,
                        size: 13.sp,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        deliveryFee,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.access_time_rounded,
                        size: 13.sp,
                        color: Colors.grey.shade500,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        deliveryTime,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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