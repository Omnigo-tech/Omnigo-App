import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoToDealCard extends StatelessWidget {
  final String imageUrl;
  final String? logoUrl;
  final String restaurantName;
  final String title;
  final String price;
  final String rating;
  final String deliveryFee;
  final String deliveryTime;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;

  const GoToDealCard({
    super.key,
    required this.imageUrl,
    this.logoUrl,
    required this.restaurantName,
    required this.title,
    required this.price,
    this.rating = '5.0',
    this.deliveryFee = '200',
    this.deliveryTime = '40min',
    this.onTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 183.89.w,
        height: 140.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1. Banner Image Section
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 72.h,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 72.h,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 72.h,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
            ),

            /// 2. Card Content Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Restaurant Logo + Name + Star Rating Row
                  Row(
                    children: [
                      // Logo Circle
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
                              ? CachedNetworkImage(
                            imageUrl: logoUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.store,
                              size: 10.r,
                              color: Colors.grey,
                            ),
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
                      Icon(Icons.star, color: const Color(0xFF0066FF), size: 10.sp),
                      SizedBox(width: 1.w),
                      Text(
                        rating,
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  /// Deal Description / Title
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 7.5.sp,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  /// Price
                  Text(
                    price.startsWith('Rs.') ? price : 'Rs. $price',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  /// Delivery Details + Plus (+) Button Row
                  Row(
                    children: [
                      Icon(Icons.delivery_dining, size: 10.sp, color: Colors.grey),
                      SizedBox(width: 2.w),
                      Text(
                        deliveryFee,
                        style: TextStyle(fontSize: 7.sp, color: Colors.grey.shade600),
                      ),
                      SizedBox(width: 6.w),
                      Icon(Icons.access_time, size: 10.sp, color: Colors.grey),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          deliveryTime,
                          style: TextStyle(fontSize: 7.sp, color: Colors.grey.shade600),
                        ),
                      ),

                      /// Add Button
                      GestureDetector(
                        onTap: onAddTap,
                        child: Container(
                          padding: EdgeInsets.all(3.r),
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
          ],
        ),
      ),
    );
  }
}