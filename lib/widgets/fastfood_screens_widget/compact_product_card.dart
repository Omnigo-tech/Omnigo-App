import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompactProductCard extends StatelessWidget {
  final String imageUrl;
  final String? logoUrl;
  final String title;
  final String restaurantName;
  final String deliveryFee;
  final String deliveryTime;
  final String rating;
  final bool isFavorite;
  final bool showOrderAgainButton;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onOrderAgainTap;
  final VoidCallback? onAddTap;

  const CompactProductCard({
    super.key,
    required this.imageUrl,
    this.logoUrl,
    required this.title,
    required this.restaurantName,
    this.deliveryFee = 'Rs.200',
    this.deliveryTime = '40 min',
    required this.rating,
    this.isFavorite = false,
    this.showOrderAgainButton = false,
    this.onTap,
    this.onFavoriteTap,
    this.onOrderAgainTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 134.w, // CSS: width: 134px
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 1. Product Image + Favorite Button Overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 70.h,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    placeholder: (context, url) {
                      return Container(
                        height: 70.h,
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
                        height: 70.h,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.fastfood,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                /// Heart / Favorite Icon (Top Right)
                Positioned(
                  top: 6.h,
                  right: 6.w,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 12.sp,
                        color: isFavorite ? const Color(0xFF0066FF) : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// 2. Card Body Content
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Restaurant Logo + Name + Rating Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Restaurant Logo Circle
                      Container(
                        width: 16.r,
                        height: 16.r,
                        margin: EdgeInsets.only(right: 4.w),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child: ClipOval(
                          child: (logoUrl != null && logoUrl!.isNotEmpty)
                              ? Image.asset(
                            logoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.store, size: 10.r, color: Colors.grey),
                          )
                              : Icon(Icons.store, size: 10.r, color: Colors.grey),
                        ),
                      ),

                      // Restaurant Name
                      Expanded(
                        child: Text(
                          restaurantName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      // Rating
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 9.sp),
                          SizedBox(width: 1.w),
                          Text(
                            rating,
                            style: TextStyle(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  /// Product Subtitle/Title
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  /// Delivery Fee + Delivery Time + Plus Button (For Popular Items)
                  if (!showOrderAgainButton)
                    Row(
                      children: [
                        Icon(Icons.directions_bike, size: 10.sp, color: Colors.grey),
                        SizedBox(width: 2.w),
                        Text(
                          deliveryFee,
                          style: TextStyle(fontSize: 7.sp, color: Colors.grey.shade600),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.access_time, size: 10.sp, color: Colors.grey),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            deliveryTime,
                            style: TextStyle(fontSize: 7.sp, color: Colors.grey.shade600),
                          ),
                        ),
                        GestureDetector(
                          onTap: onAddTap,
                          child: Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: const BoxDecoration(
                              color: Color(0xFF0066FF),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.add, size: 10.sp, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            /// 3. Order Again Button (For Craving It Again Section)
            if (showOrderAgainButton)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 22.h,
                  child: ElevatedButton(
                    onPressed: onOrderAgainTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0066FF),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    child: Text(
                      'Order Again',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}