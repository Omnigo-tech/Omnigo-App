import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:grocery_app/core/helper/constants/colors_resources.dart';

import '../../../core/di/service_locator.dart';
import '../../../data/models/fast_foods_models/restaurant_model.dart';

import '../../bloc/restaurant/restaurant_bloc.dart';
import '../../bloc/restaurant/restaurant_event.dart';
import '../../bloc/restaurant/restaurant_state.dart';
import '../../restaurant_category_products/restaurant_category_products_screen.dart';

class RestaurantDetailScreen extends StatelessWidget {

  final String restaurantId;

  const RestaurantDetailScreen({
    Key? key,
    required this.restaurantId,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => sl<RestaurantBloc>()
        ..add(
          FetchRestaurantDetailsEvent(
            restaurantId,
          ),
        ),

      child: Scaffold(
        backgroundColor:
        const Color(0xFFF8F9FB),

        body: BlocBuilder<
            RestaurantBloc,
            RestaurantState>(
          builder: (context, state) {

            // ============================================
            // LOADING
            // ============================================

            if (state is RestaurantLoadingState) {

              return const Center(
                child: CircularProgressIndicator(),
              );
            }


            // ============================================
            // ERROR
            // ============================================

            if (state is RestaurantErrorState) {

              return Center(
                child: Padding(
                  padding:
                  EdgeInsets.all(20.w),

                  child: Text(
                    'Error: ${state.message}',
                    textAlign:
                    TextAlign.center,

                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              );
            }


            // ============================================
            // LOADED
            // ============================================

            if (state is RestaurantLoadedState) {

              final restaurant =
                  state.restaurant;

              final categories =
                  state.categories;

              final selectedCategoryIndex =
                  state.selectedCategoryIndex;

              final menuSections =
                  state.menuSections;


              return SingleChildScrollView(

                child: Column(
                  children: [

                    // HEADER
                    _buildHeader(
                      context,
                      restaurant,
                    ),


                    SizedBox(
                      height: 120.h,
                    ),


                    // CATEGORIES
                    _buildCategoryTabs(
                      context,
                      categories,
                      selectedCategoryIndex,
                    ),


                    SizedBox(
                      height: 16.h,
                    ),


                    // MENU
                    _buildMenuSections(
                      context,
                      menuSections,
                      restaurant.id,
                      restaurant.name,
                    ),
                  ],
                ),
              );
            }


            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }


  // =====================================================
  // HEADER
  // =====================================================

  Widget _buildHeader(
      BuildContext context,
      RestaurantModel restaurant,
      ) {

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,

      children: [

        // COVER IMAGE
        ClipRRect(
          borderRadius:
          BorderRadius.only(
            bottomLeft:
            Radius.circular(29.r),
            bottomRight:
            Radius.circular(29.r),
          ),

          child: Container(
            height: 220.h,
            width: double.infinity,

            decoration:
            BoxDecoration(
              image:
              DecorationImage(
                image:
                NetworkImage(
                  restaurant.coverImage,
                ),
                fit: BoxFit.cover,
              ),
            ),

            child: Container(
              alignment:
              Alignment.topLeft,

              padding:
              EdgeInsets.only(
                top: 40.h,
                left: 16.w,
              ),

              color:
              Colors.black.withOpacity(
                0.2,
              ),

              child: CircleAvatar(
                backgroundColor:
                Colors.white,

                radius: 18.r,

                child: IconButton(
                  padding:
                  EdgeInsets.zero,

                  icon: Icon(
                    Icons.arrow_back,
                    size: 20.r,
                    color: Colors.black,
                  ),

                  onPressed: () =>
                      Navigator.pop(context),
                ),
              ),
            ),
          ),
        ),


        // FLOATING CARD
        Positioned(
          top: 125.h,
          left: 36.w,
          right: 36.w,

          child: Stack(
            clipBehavior:
            Clip.none,

            alignment:
            Alignment.topCenter,

            children: [

              Container(
                height: 163.h,
                width: 330.w,

                margin:
                EdgeInsets.only(
                  top: 30.h,
                ),

                padding:
                EdgeInsets.only(
                  top: 50.h,
                  bottom: 12.h,
                  left: 16.w,
                  right: 16.w,
                ),

                decoration:
                BoxDecoration(
                  color:
                  AppColors.white,

                  borderRadius:
                  BorderRadius.circular(
                    15.r,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.25),

                      blurRadius: 4.r,

                      offset:
                      Offset(0, 4.h),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    Text(
                      restaurant.name,

                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),


                    SizedBox(
                      height: 2.h,
                    ),


                    Text(
                      restaurant.tags,

                      textAlign:
                      TextAlign.center,

                      style: TextStyle(
                        fontSize: 11.sp,
                        color:
                        const Color(
                          0xFF2F80ED,
                        ),
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),


                    SizedBox(
                      height: 4.h,
                    ),


                    Text(
                      restaurant.deliveryInfo,

                      style: TextStyle(
                        fontSize: 12.sp,
                        color:
                        Colors.black87,
                        fontWeight:
                        FontWeight.w500,
                      ),
                    ),


                    SizedBox(
                      height: 6.h,
                    ),


                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,

                      children: [

                        Icon(
                          Icons.star,
                          size: 16.r,
                          color:
                          Colors.amber,
                        ),


                        SizedBox(
                          width: 4.w,
                        ),


                        Text(
                          '${restaurant.averageRating} '
                              '(${restaurant.reviewsCount})',

                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),


                        SizedBox(
                          width: 4.w,
                        ),


                        Text(
                          'See Review',

                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              // LOGO
              Positioned(
                top: 0,

                child: Container(
                  width: 80.w,
                  height: 80.r,

                  decoration:
                  BoxDecoration(
                    shape:
                    BoxShape.circle,

                    border:
                    Border.all(
                      color:
                      Colors.white,
                      width: 2,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.1),

                        blurRadius: 6.r,

                        offset:
                        const Offset(
                          0,
                          2,
                        ),
                      ),
                    ],

                    image:
                    DecorationImage(
                      image:
                      NetworkImage(
                        restaurant.logo,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  // =====================================================
  // CATEGORY TABS
  // =====================================================

  Widget _buildCategoryTabs(
      BuildContext context,
      List<RestaurantCategoryModel>
      categories,
      int selectedIndex,
      ) {

    return SizedBox(
      height: 36.h,

      child: ListView.builder(
        scrollDirection:
        Axis.horizontal,

        padding:
        EdgeInsets.symmetric(
          horizontal: 16.w,
        ),

        itemCount:
        categories.length,

        itemBuilder:
            (context, index) {

          final category =
          categories[index];

          final isSelected =
              selectedIndex == index;

          return GestureDetector(

            onTap: () {

              context
                  .read<RestaurantBloc>()
                  .add(
                ChangeCategoryTabEvent(
                  index,
                ),
              );
            },

            child: Container(
              margin:
              EdgeInsets.only(
                right: 16.w,
              ),

              padding:
              EdgeInsets.symmetric(
                horizontal: 8.w,
              ),

              decoration:
              BoxDecoration(
                border:
                Border(
                  bottom:
                  BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,

                    width: 2.5,
                  ),
                ),
              ),

              child: Text(
                category.categoryName,

                style: TextStyle(
                  fontSize: 14.sp,

                  fontWeight:
                  isSelected
                      ? FontWeight.bold
                      : FontWeight.w500,

                  color: isSelected
                      ? AppColors.primary
                      : Colors.grey.shade600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  // =====================================================
  // MENU SECTIONS
  // =====================================================

  Widget _buildMenuSections(
      BuildContext context,
      List<FoodCategorySection> menuSections,
      String restaurantId,
      String restaurantName,
      ) {

    if (menuSections.isEmpty) {

      return Padding(
        padding:
        EdgeInsets.all(30.w),

        child: Text(
          'No menu items available.',
          style: TextStyle(
            fontSize: 14.sp,
            color:
            Colors.grey.shade600,
          ),
        ),
      );
    }


    return ListView.builder(

      shrinkWrap: true,

      physics:
      const NeverScrollableScrollPhysics(),

      padding:
      EdgeInsets.symmetric(
        horizontal: 16.w,
      ),

      itemCount:
      menuSections.length,

      itemBuilder:
          (context, sectionIndex) {

        final section =
        menuSections[sectionIndex];


        return Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // SECTION HEADER
            Row(

              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,

              children: [

                Text(
                  section.categoryTitle,

                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight:
                    FontWeight.bold,
                    color: Colors.black,
                  ),
                ),


                InkWell(

                  onTap: () {
                    context
                        .read<RestaurantBloc>()
                        .add(
                      FetchCategoryProductsEvent(
                        section.categoryTitle,
                      ),
                    );
                  },

                  child: Container(
                    padding:
                    EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration:
                    BoxDecoration(
                      color:
                      AppColors.primary,
                      borderRadius:
                      BorderRadius.circular(
                        16.r,
                      ),
                    ),

                    child: InkWell(
                      onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RestaurantCategoryProductsScreen(
                                restaurantId: restaurantId,
                                restaurantName: restaurantName,
                                categoryName: section.categoryTitle,
                              ),
                            ),
                          );
                        },
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color:
                          Colors.white,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),


            SizedBox(
              height: 12.h,
            ),


            // PRODUCTS
            SizedBox(

              height: 180.h,

              child: ListView.builder(

                scrollDirection:
                Axis.horizontal,

                itemCount:
                section.items.length,

                itemBuilder:
                    (context, itemIndex) {

                  return _buildFoodCard(
                    section.items[itemIndex],
                  );
                },
              ),
            ),


            SizedBox(
              height: 24.h,
            ),
          ],
        );
      },
    );
  }


  // =====================================================
  // FOOD CARD
  // =====================================================

  Widget _buildFoodCard(
      RestaurantFoodItemModel item,
      ) {

    return Container(
      width: 140.w,

      margin:
      EdgeInsets.only(
        right: 12.w,
      ),

      padding:
      EdgeInsets.all(8.r),

      decoration:
      BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(
          16.r,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),

            blurRadius: 8.r,

            offset:
            const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Expanded(

            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: item.image.isEmpty
                  ? Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                ),
              )
                  : CachedNetworkImage(
                imageUrl: item.image,
                width: double.infinity,
                fit: BoxFit.cover,

                placeholder: (context, url) {
                  return Container(
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
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),


          SizedBox(
            height: 6.h,
          ),


          Text(
            item.name,

            maxLines: 1,

            overflow:
            TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 13.sp,
              fontWeight:
              FontWeight.bold,
              color: Colors.black,
            ),
          ),


          Text(
            item.description,

            maxLines: 1,

            overflow:
            TextOverflow.ellipsis,

            style: TextStyle(
              fontSize: 10.sp,
              color:
              Colors.grey.shade600,
            ),
          ),


          SizedBox(
            height: 6.h,
          ),


          Row(

            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,

            children: [

              Text(
                item.price,

                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  AppColors.primary,
                ),
              ),


              InkWell(

                onTap: () {},

                child: Container(

                  padding:
                  EdgeInsets.all(
                    4.r,
                  ),

                  decoration:
                  const BoxDecoration(
                    color:
                    AppColors.primary,
                    shape:
                    BoxShape.circle,
                  ),

                  child: Icon(
                    Icons.add,
                    size: 14.r,
                    color:
                    Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}