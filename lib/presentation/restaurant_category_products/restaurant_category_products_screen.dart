import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/di/service_locator.dart';
import '../../core/helper/constants/colors_resources.dart';
import '../../data/datasource/repositories/restaurant_repository.dart';
import '../../data/models/fast_foods_models/restaurant_model.dart';
import '../../data/models/fast_foods_models/restaurant_response_models.dart';

class RestaurantCategoryProductsScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String categoryName;

  const RestaurantCategoryProductsScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    required this.categoryName,
  });

  @override
  State<RestaurantCategoryProductsScreen> createState() =>
      _RestaurantCategoryProductsScreenState();
}

class _RestaurantCategoryProductsScreenState
    extends State<RestaurantCategoryProductsScreen> {
  late Future<List<RestaurantFoodItemModel>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _productsFuture = sl<RestaurantRepository>()
        .getProductsByRestaurantCategory(
      restaurantId: widget.restaurantId,
      categoryName: widget.categoryName,
    );

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<RestaurantFoodItemModel> _filterProducts(
      List<RestaurantFoodItemModel> products,
      ) {
    if (_searchQuery.isEmpty) {
      return products;
    }

    return products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery) ||
          product.description.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              height: 56.h,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(30.r),
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18.r,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      widget.restaurantName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Back button ki wajah se title center rakhne ke liye
                  SizedBox(width: 34.w),
                ],
              ),
            ),

            // ================= SEARCH =================
            Padding(
              padding: EdgeInsets.fromLTRB(
                12.w,
                10.h,
                12.w,
                6.h,
              ),
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                    fontSize: 12.sp,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                    'Search ${widget.categoryName.toLowerCase()}',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.r,
                      color: Colors.grey.shade600,
                    ),
                    contentPadding: EdgeInsets.only(
                      top: 10.h,
                    ),
                  ),
                ),
              ),
            ),

            // ================= CATEGORY TITLE + PRODUCTS =================
            Expanded(
              child:Expanded(
                child: FutureBuilder<List<RestaurantFoodItemModel>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return _buildErrorState(
                        snapshot.error.toString(),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No products found'),
                      );
                    }

                    final products = _filterProducts(snapshot.data!);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            6.h,
                            16.w,
                            10.h,
                          ),
                          child: Text(
                            widget.categoryName,
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        Expanded(
                          child: products.isEmpty
                              ? Center(
                            child: Text(
                              _searchQuery.isEmpty
                                  ? 'No products found'
                                  : 'No matching products found',
                            ),
                          )
                              : ListView.builder(
                            padding: EdgeInsets.only(
                              left: 12.w,
                              right: 12.w,
                              bottom: 20.h,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return _buildProductCard(products[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
      RestaurantFoodItemModel product,
      ) {
    final String imageUrl = product.image;

    return Container(
      height: 90.h,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // ================= PRODUCT IMAGE =================
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 82.w,
              height: 78.h,
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return _imagePlaceholder();
                },
                errorWidget: (context, url, error) {
                  return _imagePlaceholder();
                },
              )
                  : _imagePlaceholder(),
            ),
          ),

          SizedBox(width: 10.w),

          // ================= PRODUCT DETAILS =================
          Expanded(
            child: SizedBox(
              height: 78.h,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8.sp,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    'Rs.${product.price}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // ================= ADD BUTTON =================
          Padding(
            padding: EdgeInsets.only(
              right: 2.w,
            ),
            child: InkWell(
              onTap: () {
                // TODO:
                // Yahan Add To Cart API / Cart Bloc call karna hai.
                // Example:
                // context.read<CartBloc>().add(
                //   AddToCartEvent(productId: product.id),
                // );
              },
              borderRadius: BorderRadius.circular(30.r),
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F1FB),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.add,
                    size: 18.r,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(
        Icons.fastfood,
        color: Colors.grey.shade500,
        size: 30.r,
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 50.r,
              color: Colors.red,
            ),

            SizedBox(height: 12.h),

            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 16.h),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  _productsFuture =
                      sl<RestaurantRepository>()
                          .getProductsByRestaurantCategory(
                        restaurantId: widget.restaurantId,
                        categoryName: widget.categoryName,
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
}