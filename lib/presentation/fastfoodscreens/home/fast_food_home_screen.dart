// fast_food_home_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/data/models/fast_foods_models/brand_model.dart';
import 'package:grocery_app/data/models/fast_foods_models/daily_deal_model.dart';
import 'package:grocery_app/data/models/fast_foods_models/popular_product_model.dart';
import 'package:grocery_app/presentation/bloc/fast_foods/fast_food_home_bloc.dart';

import '../../../core/enums/listing_type.dart';
import '../../../core/routes/AppRoutes.dart';
import '../../../data/models/fast_foods_models/fast_delivery_restaurant_model.dart';
import '../../../data/models/fast_foods_models/food_category_model.dart';
import '../../../data/models/fast_foods_models/home_chef_model.dart';
import '../../../data/models/fast_foods_models/restaurant_model.dart' hide FoodItemModel;
import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/custom_search_bar_widget.dart';
import '../../../widgets/fastfood_screens_widget/category_selector.dart';
import '../../../widgets/fastfood_screens_widget/compact_product_card.dart';
import '../../../widgets/fastfood_screens_widget/fast_food_filter_sheet.dart';
import '../../../widgets/fastfood_screens_widget/go_to_deal_card.dart';
import '../../../widgets/fastfood_screens_widget/home_chef_meal_card.dart';
import '../../../widgets/fastfood_screens_widget/quick_delivery_card.dart';
import '../../../widgets/fastfood_screens_widget/review_recommendation_card.dart';
import '../../../widgets/popular_restaurant_card.dart';
import '../../../widgets/promotional_carousel_banner.dart';
import '../all_deal/all_deals_screen.dart';
import '../category_listing/category_listing_screen.dart';
import 'fast_food_search_screen.dart';

class FastFoodHomeScreen extends StatefulWidget {
  const FastFoodHomeScreen({Key? key}) : super(key: key);

  @override
  State<FastFoodHomeScreen> createState() => _FastFoodHomeScreenState();
}

class _FastFoodHomeScreenState extends State<FastFoodHomeScreen>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    context.read<FastFoodHomeBloc>().add(
      LoadCategoryDataEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        showBackButton: false,
        title: 'OMINIGO',
        titleStyle: theme.textTheme.labelLarge?.copyWith(
          fontSize: DimensionsResources.FONT_SIZE_EXTRA_SMALL_,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
        subTitle: 'Home, Islamabad',
        subTitleStyle: theme.textTheme.bodyMedium?.copyWith(
          fontSize: DimensionsResources.FONT_SIZE_1X_EXTRA_SMALL,
        ),
        onSubTitleTap: () {},
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: AppColors.primary,
              size: DimensionsResources.D_24.sp,
            ),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130.h),
          child: Column(
            children: [
              CustomSearchBar(
                backgroundColor: AppColors.white,
                hintText: 'Search',
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FastFoodSearchScreen(),
                    ),
                  );
                },
                onFilterTap: () {
                  FastFoodFilterSheet.show(context);
                },
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x40000000),
                    offset: Offset(0, 4.h),
                    blurRadius: 4.r,
                    spreadRadius: 0,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              BlocBuilder<FastFoodHomeBloc, FastFoodHomeState>(
                buildWhen: (previous, current) {
                  return current is FastFoodLoadedState ||
                      current is FastFoodLoadingState ||
                      current is FastFoodErrorState;
                },
                builder: (context, state) {
                  if (state is FastFoodLoadingState) {
                    return SizedBox(
                      height: 48.h,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (state is FastFoodErrorState) {
                    return SizedBox(
                      height: 48.h,
                      child: Center(
                        child: Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is FastFoodLoadedState) {
                    return SizedBox(
                      height: 45.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          final category = state.categories[index];

                          final isSelected =
                              index == state.activeTabIndex;

                          return GestureDetector(
                            onTap: () {
                              context.read<FastFoodHomeBloc>().add(
                                SelectMainCategoryEvent(
                                  categoryId: category.id,
                                  selectedIndex: index,
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 6.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.black
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Center(
                                child: Text(
                                  category.categoryName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  // Initial state / fallback
                  return SizedBox(
                    height: 48.h,
                  );
                },
              ),
              SizedBox(height: DimensionsResources.D_8.h),
            ],
          ),
        ),
      ),
      body: BlocBuilder<FastFoodHomeBloc, FastFoodHomeState>(
        builder: (context, state) {
          if (state is FastFoodLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FastFoodLoadedState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. SUB CATEGORIES
                  if (state.subCategories.isNotEmpty) ...[
              CategorySelector(
              items: state.subCategories,

              selectedIndex:
              state.selectedCategoryIndex,

              onChanged: (index) {

                final subCategory =
                state.subCategories[index];

                context.read<FastFoodHomeBloc>().add(
                  SelectSubCategoryEvent(
                    selectedCategoryIndex: index,
                    subCategoryId: subCategory.id,
                  ),
                );
              },
            ),
                    const SizedBox(height: 16),
                  ],

                  // 2. FEATURED PRODUCTS
                  if (state.productsLoading)
                    SizedBox(
                      height: 235.h,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (state.products.isNotEmpty)
                    SizedBox(
                      height: 235.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                        ),
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {

                          final product =
                          state.products[index];

                          return Container(
                            width: 271.w,
                            height: 225.h,
                            margin: EdgeInsets.only(
                              right: 12.w,
                              bottom: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(11.r),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x40000000),
                                  offset: Offset(0, 4),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                // ==================================================
                                // PRODUCT IMAGE
                                // ==================================================

                                Stack(
                                  children: [

                                    ClipRRect(
                                      borderRadius:
                                      BorderRadius.vertical(
                                        top: Radius.circular(11.r),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: product.imageUrl,
                                        height: 125.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,

                                        placeholder: (context, url) {
                                          return Container(
                                            height: 125.h,
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
                                            height: 125.h,
                                            width: double.infinity,
                                            color: Colors.orange.shade100,
                                            child: const Center(
                                              child: Icon(
                                                Icons.fastfood,
                                                size: 40,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    // ==================================================
                                    // DISCOUNT TAG
                                    // ==================================================

                                    if (product.discountTag
                                        .isNotEmpty)

                                      Positioned(
                                        top: 10.h,
                                        left: 10.w,
                                        child: Container(
                                          padding:
                                          EdgeInsets.symmetric(
                                            horizontal: 10.w,
                                            vertical: 4.h,
                                          ),
                                          decoration:
                                          BoxDecoration(
                                            color:
                                            const Color(0xFF1E5BBA),
                                            borderRadius:
                                            BorderRadius.circular(6.r),
                                          ),
                                          child: Row(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: [

                                              const Icon(
                                                Icons
                                                    .workspace_premium,
                                                size: 14,
                                                color: Colors.white,
                                              ),

                                              SizedBox(width: 4.w),

                                              Text(
                                                product.discountTag,
                                                style:
                                                TextStyle(
                                                  color:
                                                  Colors.white,
                                                  fontSize: 11.sp,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),

                                // ==================================================
                                // PRODUCT INFO
                                // ==================================================

                                Padding(
                                  padding:
                                  EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      SizedBox(height: 6.h),

                                      Row(
                                        children: [

                                          // Restaurant icon
                                          CircleAvatar(
                                            radius: 10.r,
                                            backgroundColor:
                                            Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.restaurant,
                                              size: 12,
                                              color: Colors.grey,
                                            ),
                                          ),

                                          SizedBox(width: 6.w),

                                          Expanded(
                                            child: Text(
                                              product.restaurantId,
                                              maxLines: 1,
                                              overflow:
                                              TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color:
                                                Colors.grey.shade600,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),

                                          Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16.r,
                                          ),

                                          SizedBox(width: 2.w),

                                          Text(
                                            '${product.rating.toStringAsFixed(1)} (${product.ratingCount})',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color:
                                              Colors.grey.shade700,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 8.h),

                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [

                                          // ==================================================
                                          // PRICE
                                          // ==================================================

                                          Row(
                                            children: [

                                              Text(
                                                'Rs.${product.discountPrice.toInt()}',
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w800,
                                                  fontSize: 14.sp,
                                                ),
                                              ),

                                              if (product.price >
                                                  product.discountPrice) ...[

                                                SizedBox(width: 6.w),

                                                Text(
                                                  'Rs.${product.price.toInt()}',
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color:
                                                    Colors.grey,
                                                    decoration:
                                                    TextDecoration
                                                        .lineThrough,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),

                                          // ==================================================
                                          // ADD
                                          // ==================================================

                                          GestureDetector(
                                            onTap: () {
                                              // TODO:
                                              // Add to cart event
                                            },
                                            child: Container(
                                              width: 26.r,
                                              height: 26.r,
                                              decoration:
                                              const BoxDecoration(
                                                color:
                                                Color(0xFF0066FF),
                                                shape:
                                                BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 18.r,
                                                color:
                                                Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 30.h),
                      child: Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                  // 3. PROMOTIONAL BANNERS
                  if (state.promotionDeals.isNotEmpty) ...[
                    PromotionalCarouselBanner(
                      deals: state.promotionDeals,
                      onTap: (deal) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllDealsScreen(
                              deals: state.promotionDeals,
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],

                  // 4. POPULAR NEAR ME
                  if (state.popularNearMe.isNotEmpty) ...[
                    _buildSectionHeader('Popular near me'),
                    _buildHorizontalRestaurantCards(state.popularNearMe),
                  ],

                  // 5. ALL RESTAURANTS
                  if (state.brands.isNotEmpty) ...[
                    _buildSectionHeader(
                      'All Restaurants',
                      onSeeAllTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryListingScreen(
                              title: 'All Restaurants',
                              type: ListingType.brands,
                              items: state.brands,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildVendorLogosRow(state.brands),
                  ],

                  // 6. POPULAR ITEMS
                  if (state.popularItems.isNotEmpty) ...[
                    _buildSectionHeader(
                      'Popular Items',
                      onSeeAllTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryListingScreen(
                              title: 'Popular Items',
                              type: ListingType.popularItems,
                              items: state.popularItems,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildPopularItemsSection(state.popularItems),
                  ],

                  // 7. EVERY MEAL FEELS LIKE HOME Chef
                  if (state.homeChefs.isNotEmpty) ...[
                    _buildSectionHeader(
                      'Every Meal Feels Like Home',
                      onSeeAllTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryListingScreen(
                              title: 'Every Meal Feels Like Home',
                              type: ListingType.homeChefs,
                              items: state.homeChefs,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildEveryMealSection(state.homeChefs),
                  ],
                  // 8. CRAVING IT AGAIN?
                  if (state.cravingItAgain.isNotEmpty) ...[
                    _buildSectionHeader('Craving It Again?'),
                    _buildCravingItAgainSection(state.cravingItAgain),
                  ],

                  // 9. QUICK BITES
                  if (state.fastDeliveryRestaurants.isNotEmpty) ...[
                    _buildSectionHeader(
                      'Quick Delivery',
                      onSeeAllTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryListingScreen(
                              title: 'Quick Delivery',
                              type: ListingType.fastDelivery,
                              items: state.fastDeliveryRestaurants,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildQuickBitesSection(state.fastDeliveryRestaurants),
                  ],
                  // 10. RECOMMENDED BY TASTE
                  _buildSectionHeader('Recommended by Taste'),
                  _buildRecommendedByTasteSection(),

                  // 11. YOUR GO-TO DEALS
                  if (state.dailyDeals.isNotEmpty) ...[
                    _buildSectionHeader('Your Go-To Deals'),
                    _buildGoToDealsSection(state.dailyDeals),
                  ],

                   SizedBox(height: 100.h),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  // --- SECTION HEADER BUILDER ---
  Widget _buildSectionHeader(
      String title, {
        VoidCallback? onSeeAllTap,
      }) {
    if (title.toLowerCase() == 'popular near me') {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container(height: 3.h, color: AppColors.homeBackground)),
            SizedBox(width: 8.w),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.homeBackground,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(child: Container(height: 3.h, color: AppColors.homeBackground)),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          TextButton(
            onPressed: onSeeAllTap, // Click Event Attached
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: AppColors.primary,
              minimumSize: Size(80.w, 28.h),
            ),
            child: Text(
              'See all',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- DYNAMIC SECTIONS ---
  Widget _buildHorizontalRestaurantCards(List<FoodItemModel> items) {
    return SizedBox(
      height: 212.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: EdgeInsets.only(right: 12.w),
            child: PopularRestaurantCard(
              imageUrl: item.imageUrl ?? '',
              logoUrl: item.restaurantLogo ?? '',
              title: item.name,
              subtitle: item.restaurantName,
              rating: item.rating?.toString() ?? '5.0',
              deliveryFee: 'Rs.${item.price.toInt()}',
              deliveryTime: '40 min',
              badgeText: 'Most popular',
              isFavorite: false,
              onTap: () {},
            ),
          );
        },
      ),
    );
  }

  Widget _buildVendorLogosRow(List<BrandModel> brands) {
    return SizedBox(
      height: 162.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
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
      ),
    );
  }

  Widget _buildVendorCard({
    required String title,
    required String logoUrl,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 123.w,
        height: 162.h,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F1FF),
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
          children: [
            Expanded(
              child: Center(
                child: Container(
                  width: 75.r,
                  height: 75.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8.r,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: logoUrl.isNotEmpty
                        ? CachedNetworkImage(
                      imageUrl: logoUrl,
                      fit: BoxFit.cover,

                      placeholder: (context, url) {
                        return SizedBox(
                          width: 35.r,
                          height: 35.r,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ),
                          ),
                        );
                      },

                      errorWidget: (context, url, error) {
                        return Icon(
                          Icons.restaurant_menu,
                          size: 35.r,
                          color: Colors.grey.shade600,
                        );
                      },
                    )
                        : Icon(
                      Icons.restaurant_menu,
                      size: 35.r,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 42.h,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: const Color(0xFF0066FF),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
              ),
              child: Center(
                child: Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItemsSection(List<PopularProductModel> items) {
    return SizedBox(
      height: 135.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          // JSON response parsing according to PopularProductModel
          final String imageUrl = (item.images.isNotEmpty) ? item.images.first : '';
          final String? logoUrl = item.restaurant?.logo;
          final String restaurantName = item.restaurant?.name ?? 'Restaurant';

          // Checking rating average
          final String rating = (item.rating != null && item.rating!.average > 0)
              ? item.rating!.average.toString()
              : '5.0';

          // Price calculation (discounted price if available, otherwise original price)
          final num finalPrice = (item.discountPrice > 0) ? item.discountPrice : item.price;

          return CompactProductCard(
            imageUrl: imageUrl,
            logoUrl: logoUrl,
            restaurantName: restaurantName,
            title: item.name,
            rating: rating,
            deliveryFee: 'Rs. ${finalPrice.toInt()}',
            deliveryTime: '40 min',
            isFavorite: false,
            showOrderAgainButton: false,
            onFavoriteTap: () {},
            onAddTap: () {},
            onTap: () {},
          );
        },
      ),
    );;
  }

  Widget _buildEveryMealSection(List<HomeChefModel> chefs) {
    return SizedBox(
      height: 210.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: chefs.length,
        itemBuilder: (context, index) {
          final chef = chefs[index];
          return HomeChefMealCard(
            imageUrl: chef.coverImage,
            title: chef.name,
            subtitle: chef.description,
            price: 'Rs. ${chef.deliveryFee.toInt()}',
            time: '${chef.minDeliveryTime}-${chef.maxDeliveryTime} min',
            rating: '${chef.ratingAverage}',
            discountTag: chef.offer,
          );
        },
      ),
    );
  }

  Widget _buildCravingItAgainSection(List<FoodItemModel> items) {
    return SizedBox(
      height: 155.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return CompactProductCard(
            imageUrl: item.imageUrl ?? '',
            logoUrl: item.restaurantLogo ?? '',
            restaurantName: item.restaurantName,
            title: item.name,
            rating: item.rating?.toString() ?? '5.0',
            isFavorite: true,
            showOrderAgainButton: true,
            onFavoriteTap: () {},
            onOrderAgainTap: () {},
            onTap: () {},
          );
        },
      ),
    );
  }

  Widget _buildQuickBitesSection(List<FastDeliveryRestaurantModel> restaurants) {
    return SizedBox(
      height: 158.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];

          // Custom Offer Title Check (Fall back to default if null/empty)
          final offerText = restaurant.offer != null && restaurant.offer!.title.isNotEmpty
              ? restaurant.offer!.title
              : 'Fast Delivery';

          return QuickDeliveryCard(
            imageUrl: restaurant.coverImage.isNotEmpty
                ? restaurant.coverImage
                : restaurant.logo,
            restaurantName: restaurant.name,
            deliveryTime: '${restaurant.deliveryTime.min}-${restaurant.deliveryTime.max} min',
            rating: restaurant.rating.average.toString(),
            offerTitle: offerText,
            offerIcon: restaurant.offer?.icon,
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.restaurantScreen,
                arguments: restaurant,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRecommendedByTasteSection() {
    return SizedBox(
      height: 101.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return const ReviewRecommendationCard(
            userAvatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=200',
            userName: 'Naeem Khan',
            reviewText: 'I ordered special biryani platter from them & its super tasty. 10/10 recommendation!',
            rating: '5.0',
            vendorLogoUrl: '',
          );
        },
      ),
    );
  }

  Widget _buildGoToDealsSection(List<DailyDealModel> items) {
    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GoToDealCard(
            imageUrl: item.image ?? '',
            logoUrl: item.restaurant!.logo ?? '',
            restaurantName: item.restaurant!.name,
            title: item.title,
            price: 'Rs.${item.discountPrice.toInt()}/-',
            rating: item.restaurant!.rating?.average.toString() ?? '5.0',
            deliveryFee: item.restaurant!.deliveryFee.toString(),
            deliveryTime: '${item.restaurant!.deliveryTime!.min}-${item.restaurant!.deliveryTime!.max} min',
            onAddTap: () {},
            onTap: () {},
          );
        },
      ),
    );
  }
}