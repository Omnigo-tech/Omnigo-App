import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
import '../../../core/helper/utils/phone_formatter.dart';
import '../../bloc/grocery_details/item_detail_event.dart';
import '../../screens/user_interface/address_list/address_screen.dart';
import '../grocery_bloc/grocery_bloc.dart';
import '../grocery_bloc/grocery_event.dart';
import '../grocery_bloc/grocery_state.dart';

class GroceryHomeScreen extends StatelessWidget {
  final String nameCategories;
  const GroceryHomeScreen({super.key, required this.nameCategories});

  @override
  Widget build(BuildContext context) {
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
                        value: context.read<GroceryDetailBloc>()
                          ..add(GetCartItemsEvent()),
                        child: MyCartScreen(),
                      ),
                    ),
                  );
                },
                icon: SvgPicture.asset(
                  ImageResource.ICON_ORDER,
                  width: 24.w,
                  height: 21.h,
                  colorFilter: const ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
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
      height: 100.h,
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          if (state.categories.isEmpty) {
            return const SizedBox.shrink();
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final selectedIndex = state.categories.indexWhere(
                  (category) => category.name == state.selectedCategory,
            );

            if (selectedIndex != -1 && _categoryScrollController.hasClients) {
              _categoryScrollController.animateTo(
                selectedIndex * 82.0,
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
              final category = state.categories[index];
              final categoryName = category.name;
              final imageUrl = category.image;
              final isSelected = state.selectedCategory == categoryName;

              return GestureDetector(
                onTap: () {
                  context.read<GroceryBloc>().add(
                    SelectCategoryEvent(categoryName),
                  );
                },
                child: Container(
                  width: 72.w,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Outer Border Circle Container
                      Container(
                        width: 58.w,
                        height: 58.h,
                        // Consistent 3px padding so image stays inside circle in both states
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0264D3)
                                : const Color(0x23323B48), // Grey border for unselected
                            width: isSelected ? 2.w : 1.w,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            )
                          ]
                              : [],
                        ),
                        // Inner Perfect Circle for Image Background
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F8F8),
                            shape: BoxShape.circle,
                          ),
                          clipBehavior: Clip.antiAlias, // Ensures sharp circle clip
                          child: imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                            imageUrl: ImageUrl.fixImageUrl(imageUrl),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                          )
                              : Icon(
                            Icons.image_not_supported,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Flexible(
                        child: Text(
                          categoryName,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            height: 1.2,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF0264D3)
                                : Colors.black,
                          ),
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
                    ImageUrl.fixImageUrl(item.image),
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
