import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickDeliveryCard extends StatelessWidget {
  final String imageUrl;
  final String restaurantName;
  final String deliveryTime;
  final String rating;
  final String offerTitle;
  final String? offerIcon;
  final VoidCallback? onTap;

  const QuickDeliveryCard({
    super.key,
    required this.imageUrl,
    required this.restaurantName,
    required this.deliveryTime,
    required this.rating,
    this.offerTitle = 'Fast Delivery',
    this.offerIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 192.w,
        height: 158.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(12.r)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 95.h,
                    width: double.infinity,
                    fit: BoxFit.cover,

                    placeholder: (context, url) {
                      return Container(
                        height: 95.h,
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
                        height: 95.h,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.restaurant,
                          color: Colors.grey.shade500,
                          size: 30.sp,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0066FF),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (offerIcon != null && offerIcon!.isNotEmpty)
                          Text(
                            '$offerIcon ',
                            style: TextStyle(fontSize: 9.sp),
                          )
                        else
                          Icon(
                            Icons.bolt,
                            color: Colors.white,
                            size: 10.sp,
                          ),
                        Text(
                          offerTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurantName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 12.sp),
                          SizedBox(width: 2.w),
                          Text(
                            rating,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Fast Delivery within $deliveryTime',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.grey.shade600,
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