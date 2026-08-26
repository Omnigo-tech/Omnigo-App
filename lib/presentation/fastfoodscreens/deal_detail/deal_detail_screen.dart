import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/data/datasource/repositories/fast_food_home_repository.dart';

import '../../../core/di/service_locator.dart';
import '../../../data/models/fast_foods_models/deal_details_model.dart';

class DealDetailScreen extends StatefulWidget {
  final String dealId;

  const DealDetailScreen({
    super.key,
    required this.dealId,
  });

  @override
  State<DealDetailScreen> createState() =>
      _DealDetailScreenState();
}

class _DealDetailScreenState
    extends State<DealDetailScreen> {

  late Future<DealDetailModel> _dealFuture;

  int quantity = 1;

  @override
  void initState() {
    super.initState();

    _dealFuture = sl<FastFoodHomeRepository>()
        .getDealDetails(widget.dealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: FutureBuilder<DealDetailModel>(
        future: _dealFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return _buildError(
              snapshot.error.toString(),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('Deal not found'),
            );
          }

          final deal = snapshot.data!;

          return _buildDetailScreen(deal);
        },
      ),
    );
  }

  Widget _buildDetailScreen(
      DealDetailModel deal,
      ) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  _buildBanner(deal),

                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _buildRestaurant(deal),

                        SizedBox(height: 14.h),

                        Text(
                          deal.title,
                          style: TextStyle(
                            fontSize: 21.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(height: 6.h),

                        Text(
                          deal.description,
                          style: TextStyle(
                            fontSize: 13.sp,
                            height: 1.4,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        SizedBox(height: 18.h),

                        _buildPrice(deal),

                        SizedBox(height: 18.h),

                        _buildIncluded(deal),

                        SizedBox(height: 18.h),

                        _buildValidTill(deal),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildBottomBar(deal),
        ],
      ),
    );
  }

  Widget _buildBanner(
      DealDetailModel deal,
      ) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: deal.bannerImage.isNotEmpty
              ? deal.bannerImage
              : deal.image,
          width: double.infinity,
          height: 230.h,
          fit: BoxFit.cover,

          placeholder: (context, url) {
            return Container(
              width: double.infinity,
              height: 230.h,
              color: Colors.grey.shade200,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },

          errorWidget: (context, url, error) {
            return Container(
              width: double.infinity,
              height: 230.h,
              color: Colors.grey.shade200,
              child: const Icon(
                Icons.image_not_supported,
                size: 50,
              ),
            );
          },
        ),

        Positioned(
          top: 12.h,
          left: 12.w,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                    Colors.black.withOpacity(0.15),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                size: 20.r,
              ),
            ),
          ),
        ),

        if (deal.tag.isNotEmpty)
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius:
                BorderRadius.circular(20.r),
              ),
              child: Text(
                deal.tag,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRestaurant(
      DealDetailModel deal,
      ) {
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              deal.restaurant.logo,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.restaurant,
                );
              },
            ),
          ),
        ),

        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                deal.restaurant.name,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                deal.dealType,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(
      DealDetailModel deal,
      ) {
    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.center,
      children: [
        Text(
          'Rs. ${deal.pricing.discountPrice.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),

        SizedBox(width: 8.w),

        Text(
          'Rs. ${deal.pricing.originalPrice.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey,
            decoration:
            TextDecoration.lineThrough,
          ),
        ),

        const Spacer(),

        Text(
          'You Save Rs. ${deal.pricing.amountSaved.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildIncluded(
      DealDetailModel deal,
      ) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'What included',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 8.h),

        ...deal.products.map(
              (product) {
            return Padding(
              padding:
              EdgeInsets.only(bottom: 7.h),
              child: Row(
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      '${product.quantity}x ${product.name}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildValidTill(
      DealDetailModel deal,
      ) {
    String validDate = 'N/A';

    if (deal.validUntil != null) {
      validDate =
      '${deal.validUntil!.day.toString().padLeft(2, '0')} '
          '${_monthName(deal.validUntil!.month)} '
          '${deal.validUntil!.year}';
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Valid Till',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 8.h),

        Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16.r,
              color: Colors.grey.shade600,
            ),
            SizedBox(width: 8.w),
            Text(
              validDate,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),

        SizedBox(height: 14.h),

        Divider(
          color: Colors.grey.shade300,
        ),
      ],
    );
  }

  Widget _buildBottomBar(
      DealDetailModel deal,
      ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        14.w,
        10.h,
        14.w,
        14.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius:
              BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: quantity > 1
                      ? () {
                    setState(() {
                      quantity--;
                    });
                  }
                      : null,
                  icon: Icon(
                    Icons.remove,
                    size: 17.r,
                  ),
                ),

                Text(
                  '$quantity',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    size: 17.r,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              'Rs. ${(deal.pricing.discountPrice * quantity).toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          SizedBox(
            height: 42.h,
            child: ElevatedButton.icon(
              onPressed: () {
                // Add deal to cart API yahan connect hogi
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                size: 18.r,
              ),
              label: const Text('Add to cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 45,
            ),
            SizedBox(height: 10.h),
            Text(
              'Failed to load deal',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 15.h),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _dealFuture =
                      sl<FastFoodHomeRepository>()
                          .getDealDetails(
                        widget.dealId,
                      );
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month];
  }
}