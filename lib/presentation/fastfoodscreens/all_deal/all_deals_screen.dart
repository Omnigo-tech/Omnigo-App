import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/data/models/fast_foods_models/promotion_deal_model.dart';

import '../deal_detail/deal_detail_screen.dart';
class AllDealsScreen extends StatelessWidget {
  final List<PromotionDealModel> deals;

  const AllDealsScreen({
    super.key,
    required this.deals,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Today Deals',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: deals.isEmpty
          ? Center(
        child: Text(
          'No deals available',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(12.w),
        itemCount: deals.length,
        itemBuilder: (context, index) {
          final deal = deals[index];

          return _buildDealCard(
            context,
            deal,
          );
        },
      ),
    );
  }

  Widget _buildDealCard(
      BuildContext context,
      PromotionDealModel deal,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DealDetailScreen(
              dealId: deal.id,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12.r),
              ),
              child: CachedNetworkImage(
                imageUrl: deal.bannerImage,
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,

                placeholder: (context, url) {
                  return Container(
                    width: double.infinity,
                    height: 150.h,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },

                errorWidget: (context, url, error) {
                  return Container(
                    width: double.infinity,
                    height: 150.h,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  if (deal.restaurant != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      deal.restaurant!.name,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],

                  SizedBox(height: 8.h),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View Deal',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),

                      Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 17.r,
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