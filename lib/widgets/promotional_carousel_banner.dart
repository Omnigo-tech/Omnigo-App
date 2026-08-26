import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/models/fast_foods_models/promotion_deal_model.dart';

class PromotionalCarouselBanner extends StatefulWidget {
  final List<PromotionDealModel> deals;
  final Function(PromotionDealModel deal)? onTap;

  const PromotionalCarouselBanner({
    super.key,
    required this.deals,
    this.onTap,
  });

  @override
  State<PromotionalCarouselBanner> createState() =>
      _PromotionalCarouselBannerState();
}

class _PromotionalCarouselBannerState
    extends State<PromotionalCarouselBanner> {

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    // No promotion deals
    if (widget.deals.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        CarouselSlider.builder(
          itemCount: widget.deals.length,

          options: CarouselOptions(
            height: 164.h,
            viewportFraction: 0.92,

            autoPlay: widget.deals.length > 1,

            autoPlayInterval:
            const Duration(seconds: 4),

            autoPlayAnimationDuration:
            const Duration(milliseconds: 800),

            autoPlayCurve:
            Curves.fastOutSlowIn,

            enlargeCenterPage: true,

            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),

          itemBuilder: (
              context,
              index,
              realIndex,
              ) {

            final deal = widget.deals[index];

            return GestureDetector(
              onTap: () {
                widget.onTap?.call(deal);
              },

              child: Container(
                width: 354.w,
                height: 164.h,

                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(7.r),

                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),

                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(7.r),

                  child: CachedNetworkImage(
                    imageUrl: deal.bannerImage,

                    width: double.infinity,
                    height: double.infinity,

                    fit: BoxFit.cover,

                    placeholder: (context, url) {
                      return Container(
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
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade600,
                              Colors.blue.shade400,
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Special Deal',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.sp,
                              ),
                            ),

                            SizedBox(height: 4.h),

                            Text(
                              deal.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),

        // Dots
        if (widget.deals.length > 1) ...[
          SizedBox(height: 10.h),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.center,

            children:
            widget.deals.asMap().entries.map(
                  (entry) {

                final isSelected =
                    _currentIndex == entry.key;

                return AnimatedContainer(
                  duration:
                  const Duration(
                    milliseconds: 300,
                  ),

                  width:
                  isSelected ? 18.w : 6.w,

                  height: 6.h,

                  margin:
                  EdgeInsets.symmetric(
                    horizontal: 3.w,
                  ),

                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(4.r),

                    color: isSelected
                        ? const Color(0xFF0066FF)
                        : Colors.grey.shade300,
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ],
    );
  }
}