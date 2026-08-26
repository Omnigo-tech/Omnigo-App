import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/enums/listing_type.dart';
import '../../../core/routes/AppRoutes.dart';
import '../../../widgets/fastfood_screens_widget/compact_product_card.dart';

class CategoryListingScreen extends StatefulWidget {
  final String title;
  final ListingType type;
  final List<dynamic> items;

  const CategoryListingScreen({
    super.key,
    required this.title,
    required this.type,
    required this.items,
  });

  @override
  State<CategoryListingScreen> createState() => _CategoryListingScreenState();
}

class _CategoryListingScreenState extends State<CategoryListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items;
      } else {
        filteredItems = widget.items.where((item) {
          final name = (item.name ?? '').toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: const Color(0xFF0066FF),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              height: 45.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ),

          // DYNAMIC GRID CONTENT
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
              child: Text(
                'No items found',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
            )
                : _buildGridContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildGridContent() {
    switch (widget.type) {
    // 1. ALL RESTAURANTS / BRANDS GRID (Design 17)
      case ListingType.brands:
        return GridView.builder(
          padding: EdgeInsets.all(16.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12.w,
            mainAxisSpacing: 16.h,
            childAspectRatio: 0.76,
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final brand = filteredItems[index];
            return _buildVendorCard(
              title: brand.name,
              logoUrl: brand.logo,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.restaurantScreen,
                  arguments: brand.id,
                );
              },
            );
          },
        );

    // 2. POPULAR ITEMS / PRODUCTS GRID (Design 18)
      case ListingType.popularItems:
      case ListingType.homeChefs:
      case ListingType.fastDelivery:
      default:
      return GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 0.65,
        ),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];

          // Safe Data Extraction from Dynamic Model
          final String imageUrl = item.image ?? item.coverImage ?? item.logo ?? '';
          final String? logoUrl = item.logo ?? item.restaurantLogo;
          final String title = item.title ?? item.name ?? '';
          final String restaurantName = item.restaurantName ?? item.vendorName ?? 'Vendor';

          // Delivery Fee Handling
          final String deliveryFee = item.deliveryFee != null
              ? 'Rs.${item.deliveryFee}'
              : 'Rs.200';

          // Delivery Time Handling (String vs Map/Object model)
          String deliveryTime = '40 min';
          if (item.deliveryTime != null) {
            if (item.deliveryTime is String) {
              deliveryTime = item.deliveryTime;
            } else {
              deliveryTime = '${item.deliveryTime.min}-${item.deliveryTime.max} min';
            }
          }

          // Rating Handling (num vs Model object)
          String rating = '4.5';
          if (item.rating != null) {
            if (item.rating is num) {
              rating = item.rating.toString();
            } else if (item.rating.average != null) {
              rating = item.rating.average.toString();
            }
          }

          return CompactProductCard(
            imageUrl: imageUrl,
            logoUrl: logoUrl,
            title: title,
            restaurantName: restaurantName,
            deliveryFee: deliveryFee,
            deliveryTime: deliveryTime,
            rating: rating,
            isFavorite: item.isFavorite ?? false,
            showOrderAgainButton: widget.type == ListingType.popularItems ? false : false,
            onTap: () {
              // Handle Item Click (e.g. Navigate to Product Detail)
            },
            onFavoriteTap: () {
              // Handle Favorite Toggle
            },
            onAddTap: () {
              // Handle Add to Cart
            },
            onOrderAgainTap: () {
              // Handle Re-order Action
            },
          );
        },
      );
    }
  }

  // BRAND / RESTAURANT CARD WIDGET
  Widget _buildVendorCard({
    required String title,
    required String logoUrl,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8F1FF),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 60.r,
                  height: 60.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: logoUrl,
                      fit: BoxFit.cover,

                      placeholder: (context, url) {
                        return SizedBox(
                          width: 30.r,
                          height: 30.r,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ),
                          ),
                        );
                      },

                      errorWidget: (context, url, error) {
                        return Icon(
                          Icons.restaurant,
                          size: 30.r,
                          color: Colors.grey,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 36.h,
              decoration: BoxDecoration(
                color: const Color(0xFF0066FF),
                borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(12.r)),
              ),
              child: Center(
                child: Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}