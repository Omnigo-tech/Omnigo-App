import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewRecommendationCard extends StatelessWidget {
  final String userAvatarUrl;
  final String userName;
  final String reviewText;
  final String rating;
  final String vendorLogoUrl;

  const ReviewRecommendationCard({
    super.key,
    required this.userAvatarUrl,
    required this.userName,
    required this.reviewText,
    required this.rating,
    required this.vendorLogoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 295.w, // CSS: width: 295px
      height: 101.h, // CSS: height: 101px
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1FF), // Soft light blue tint
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF0066FF).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(userAvatarUrl),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userName,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0066FF),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 10.sp),
                          SizedBox(width: 2.w),
                          Text(
                            rating,
                            style: TextStyle(color: Colors.white, fontSize: 9.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  reviewText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9.sp, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}