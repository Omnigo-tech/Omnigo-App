import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/data/models/grocery-item.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/screens/user_interface/details/grocery_details.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/filter_bottom_sheet.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/search_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';
import '../../screens/user_interface/address_list/address_screen.dart';
import '../grocery_bloc/grocery_bloc.dart';
import '../grocery_bloc/grocery_event.dart';
import '../grocery_bloc/grocery_state.dart';

class GroceryHomeScreen extends StatelessWidget {
  final String nameCategories;
  const GroceryHomeScreen({super.key, required this.nameCategories});

  @override
  Widget build(BuildContext context) {
    // Pass the category through to GroceryView. The actual
    // LoadGroceryEvent(initialCategory: ...) dispatch already happens
    // once in route_generator.dart when this route is built — GroceryView
    // does NOT re-dispatch a plain LoadGroceryEvent() in initState
    // anymore, since that would reset selectedCategory back to the first
    // category and undo the navigation.
    return GroceryView(initialCategory: nameCategories);
  }
}

class GroceryView extends StatefulWidget {
  final String? initialCategory;
  const GroceryView({super.key, this.initialCategory});

  @override
  State<GroceryView> createState() => _GroceryViewState();
}

class _GroceryViewState extends State<GroceryView> {
  final ScrollController _categoryScrollController = ScrollController();

  // Replace localhost with real IP for physical device testing
  String fixImageUrl(String url) {
    return url.replaceAll('localhost', '192.168.2.104');
  }

  // NOTE: initState intentionally does NOT dispatch LoadGroceryEvent.
  // route_generator.dart's Builder already dispatches
  // LoadGroceryEvent(initialCategory: category) exactly once when this
  // route is created, using the SAME shared GroceryBloc instance
  // (sl<GroceryBloc>()). Dispatching again here would either:
  //   (a) re-trigger the API call unnecessarily, or
  //   (b) if it raced with the route's dispatch, override
  //       selectedCategory back to the first category.
  // If you ever need this screen reachable WITHOUT going through
  // route_generator's groceryhome case, add a guard here instead, e.g.:
  //   if (context.read<GroceryBloc>().state.allItems.isEmpty) {
  //     context.read<GroceryBloc>().add(
  //       LoadGroceryEvent(initialCategory: widget.initialCategory),
  //     );
  //   }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 10.h),
            _buildSearchBar(context),
            SizedBox(height: 12.h),
            _buildCategoryHeader(context),
            _buildCategories(context),
            SizedBox(height: DimensionsResources.D_10.h),
            Expanded(child: _buildProductsWithBackground()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          final address = state.selectedAddress;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.blue),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AddressBloc>(),
                          child: const AddressListScreen(),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address?.locationname ?? "Home",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18.sp,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        address?.address ?? "Select your address",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<GroceryDetailBloc>(),
                        child: const MyCartScreen(),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 24.sp,
                  color: AppColors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<GroceryBloc>(),
                child: const SearchScreen(),
              ),
            ),
          );
        },
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 209, 221, 245),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade500, size: 22.sp),
              SizedBox(width: 10.w),
              Text(
                "Search something",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Categories",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<GroceryBloc>(),
                  child: const FilterBottomSheet(flag: 0),
                ),
              );
            },
            icon: Icon(Icons.tune, size: 22.sp, color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 96.h,
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          if (state.categories.isEmpty) {
            return const SizedBox.shrink();
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final index = state.categories.indexOf(state.selectedCategory);
            if (index != -1 && _categoryScrollController.hasClients) {
              _categoryScrollController.animateTo(
                index * 78.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          });

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            controller: _categoryScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (_, index) {
              final categoryName = state.categories[index];
              final isSelected = state.selectedCategory == categoryName;
              final imageUrl = state.categoryImages[categoryName] ?? "";

              return GestureDetector(
                onTap: () {
                  context.read<GroceryBloc>().add(
                    SelectCategoryEvent(categoryName),
                  );
                },
                child: Container(
                  width: 70.w,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 70.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2F6FED)
                                : const Color.fromARGB(0, 151, 153, 153),
                            width: 2.w,
                          ),
                        ),
                        padding: EdgeInsets.all(isSelected ? 3 : 0),
                        child: ClipOval(
                          child: Container(
                            color: Colors.grey.shade100,
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    fixImageUrl(imageUrl),
                                    fit: BoxFit.fill,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey.shade400,
                                    ),
                                  )
                                : Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey.shade400,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        categoryName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFF2F6FED)
                              : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProductsWithBackground() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 100.h,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 70, 126, 211),
                  Colors.white,
                ],
                stops: [0.0, 0.5, 1.2],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 100.h,
          child: Image.asset(
            ImageResource.GROCERY_BACKGROUND,
            fit: BoxFit.fill,
          ),
        ),
        _buildProducts(),
      ],
    );
  }

  Widget _buildProducts() {
    return BlocBuilder<GroceryBloc, GroceryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null && state.error!.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                const Text(
                  "Something went wrong",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => context.read<GroceryBloc>().add(
                    LoadGroceryEvent(initialCategory: widget.initialCategory),
                  ),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildBanner(),
              SizedBox(height: 10.h),
              state.filteredItems.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Text(
                        "No products in this category",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    )
                  : _buildProductGrid(state.filteredItems),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBanner() {
    return CarouselSlider.builder(
      itemCount: ImageResource.banners.length,
      itemBuilder: (context, index, realIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              ImageResource.banners[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 150.h,
        autoPlay: true,
        viewportFraction: 1,
      ),
    );
  }

  Widget _buildProductGrid(List<dynamic> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.68,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
      ),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            final detailItem = GroceryItemModel(
              id: item.id,
              name: item.name,
              image: item.image,
              price: item.price,
              description: item.description ?? "No description available.",
              weight: item.weight ?? "N/A",
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<GroceryDetailBloc>(),
                  child: DetailScreen(item: detailItem),
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: (item.image != null && item.image.isNotEmpty)
                      ? Image.network(
                          fixImageUrl(item.image),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade400,
                          ),
                        )
                      : Icon(
                          Icons.image_not_supported,
                          color: Colors.grey.shade400,
                        ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                item.weight != null && item.weight.isNotEmpty
                    ? "${item.name} (${item.weight})"
                    : item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Rs. ${item.price}",
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/data/models/grocery-item.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/screens/user_interface/details/grocery_details.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/filter_bottom_sheet.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/search_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';
import '../../screens/user_interface/address_list/address_screen.dart';
import '../grocery_bloc/grocery_bloc.dart';
import '../grocery_bloc/grocery_event.dart';
import '../grocery_bloc/grocery_state.dart';

class GroceryHomeScreen extends StatelessWidget {
  final String nameCategories;
  const GroceryHomeScreen({super.key, required this.nameCategories});

  @override
  Widget build(BuildContext context) {
    return const GroceryView();
    //return GroceryView(initialCategory: nameCategories);
  }
}

class GroceryView extends StatefulWidget {
  //final String? initialCategory;

  const GroceryView({super.key}); //, this.initialCategory});

  @override
  State<GroceryView> createState() => _GroceryViewState();
}

class _GroceryViewState extends State<GroceryView> {
  final ScrollController _categoryScrollController = ScrollController();

  // Replace localhost with real IP for physical device testing for images
  String fixImageUrl(String url) {
    return url.replaceAll('localhost', '192.168.2.104');
  }

  @override
  void initState() {
    super.initState();
    context.read<GroceryBloc>().add(LoadGroceryEvent());

    /*super.initState();
    context.read<GroceryBloc>().add(
      LoadGroceryEvent(initialCategory: widget.initialCategory),
    );*/
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 10.h),
            _buildSearchBar(context),
            SizedBox(height: 12.h),
            _buildCategoryHeader(context),
            _buildCategories(context),
            SizedBox(height: DimensionsResources.D_10.h),
            // Everything below categories sits on a fixed background
            Expanded(child: _buildProductsWithBackground()),
          ],
        ),
      ),
    );
  }

  // Header:  dropdown + address line + cart icon (Figma match)
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          final address = state.selectedAddress;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_outlined, color: Colors.blue),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AddressBloc>(),
                          child: const AddressListScreen(),
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address?.locationname ?? "Home",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18.sp,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        address?.address ?? "Select your address",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<GroceryDetailBloc>(),
                        child: const MyCartScreen(),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 24.sp,
                  color: AppColors.black,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Search bar: "Search something" — light grey, no border (Figma match)
  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<GroceryBloc>(),
                child: const SearchScreen(),
              ),
            ),
          );
        },
        child: Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 209, 221, 245),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade500, size: 22.sp),
              SizedBox(width: 10.w),
              Text(
                "Search something",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // "Categories" + filter icon (Figma match)
  Widget _buildCategoryHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Categories",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<GroceryBloc>(),
                  child: const FilterBottomSheet(flag: 0),
                ),
              );
            },
            icon: Icon(Icons.tune, size: 22.sp, color: AppColors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 96.h,
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          if (state.categories.isEmpty) {
            return const SizedBox.shrink();
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final index = state.categories.indexOf(state.selectedCategory);
            if (index != -1 && _categoryScrollController.hasClients) {
              _categoryScrollController.animateTo(
                index * 78.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          });

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            controller: _categoryScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (_, index) {
              final categoryName = state.categories[index];
              final isSelected = state.selectedCategory == categoryName;
              final imageUrl = state.categoryImages[categoryName] ?? "";

              return GestureDetector(
                onTap: () {
                  context.read<GroceryBloc>().add(
                    SelectCategoryEvent(categoryName),
                  );
                },
                child: Container(
                  width: 70.w,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 70.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2F6FED)
                                : Colors.transparent,
                            width: 2.5.w,
                          ),
                        ),
                        padding: EdgeInsets.all(isSelected ? 3 : 0),
                        child: ClipOval(
                          child: Container(
                            color: Colors.grey.shade100,
                            child: imageUrl.isNotEmpty
                                ? Image.network(
                                    fixImageUrl(imageUrl),
                                    fit: BoxFit.fill,
                                    errorBuilder: (_, _, _) => Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey.shade400,
                                    ),
                                  )
                                : Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey.shade400,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Fixed-height wrapper for text so it can never
                      // push the column taller than the SizedBox above
                      //SizedBox(
                      //height: 28.h,
                      //child:
                      Text(
                        categoryName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFF2F6FED)
                              : Colors.grey.shade700,
                        ),
                      ),
                      //),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // CATEGORY_BACKGROUND fixed behind grid+banner — content scrolls on
  // top of it. Confirmed constant name: ImageResource.CATEGORY_BACKGROUND

  Widget _buildProductsWithBackground() {
    return Stack(
      children: [
        // Layer 1: light blue → white gradient (the color from Figma)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 100.h,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color.fromARGB(255, 70, 126, 211), // dark center
                  Colors.white, // light bottom (same as top)
                ],
                stops: [0.0, 0.5, 1.2],
              ),
            ),
          ),
        ),
        // Layer 2: your transparent GROCERY_BACKGROUND pattern on top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 100.h,
          child: Image.asset(
            ImageResource.GROCERY_BACKGROUND,
            fit: BoxFit.fill,
          ),
        ),
        _buildProducts(), // grid scrolls on top of both layers
      ],
    );
  }

  Widget _buildProducts() {
    return BlocBuilder<GroceryBloc, GroceryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error != null && state.error!.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                const Text(
                  "Something went wrong",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () =>
                      context.read<GroceryBloc>().add(LoadGroceryEvent()),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        // Banner + grid now scroll together inside one ScrollView,
        // sitting on top of the fixed background image.
        return SingleChildScrollView(
          child: Column(
            children: [
              //SizedBox(height: 6.h),
              _buildBanner(),
              SizedBox(height: 10.h),
              state.filteredItems.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: Text(
                        "No products in this category",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    )
                  : _buildProductGrid(state.filteredItems),
            ],
          ),
        );
      },
    );
  }

  // Banner restored using ImageResource.banners (local assets)
  Widget _buildBanner() {
    return CarouselSlider.builder(
      itemCount: ImageResource.banners.length,
      itemBuilder: (context, index, realIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              ImageResource.banners[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 150.h,
        autoPlay: true,
        viewportFraction: 1,
      ),
    );
  }

  // Product grid: 3 columns, name can wrap 2 lines, "Rs." price prefix
  Widget _buildProductGrid(List<dynamic> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.68,
        crossAxisSpacing: 10,
        mainAxisSpacing: 14,
      ),
      itemCount: items.length,
      itemBuilder: (_, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () {
            final detailItem = GroceryItemModel(
              id: item.id,
              name: item.name,
              image: item.image,
              price: item.price,
              description: item.description ?? "No description available.",
              weight: item.weight ?? "N/A",
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<GroceryDetailBloc>(),
                  child: DetailScreen(item: detailItem),
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: item.image.isNotEmpty
                      ? Image.network(
                          fixImageUrl(item.image),
                          fit: BoxFit.contain,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade400,
                          ),
                        )
                      : Icon(
                          Icons.image_not_supported,
                          color: Colors.grey.shade400,
                        ),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                item.weight != null && item.weight.isNotEmpty
                    ? "${item.name} (${item.weight})"
                    : item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Rs. ${item.price}",
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}*/
