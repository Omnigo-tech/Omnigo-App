import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
  }
}

class GroceryView extends StatefulWidget {
  const GroceryView({super.key});

  @override
  State<GroceryView> createState() => _GroceryViewState();
}

class _GroceryViewState extends State<GroceryView> {
  final ScrollController _scrollController = ScrollController();
  late final PageController _pageController;

  // Fix localhost → real IP for physical device
  String fixImageUrl(String url) {
    return url.replaceAll('localhost', '192.168.1.106');
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Load products from API — categories & suggestions extracted in bloc
    context.read<GroceryBloc>().add(LoadGroceryEvent());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: DimensionsResources.D_10),
            _buildSearchBar(context),
            SizedBox(height: DimensionsResources.D_12),
            _buildCategoryHeader(context),
            SizedBox(height: DimensionsResources.D_10),
            _buildCategories(context),
            SizedBox(height: DimensionsResources.D_10),
            _buildProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(
              ImageResource.BACK_ICON,
              width: DimensionsResources.D_30.w,
              height: DimensionsResources.D_30.h,
              colorFilter: const ColorFilter.mode(
                AppColors.darkSecondary,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.location_on, color: Colors.green),
          const SizedBox(width: 6),
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              final address = state.selectedAddress;
              return Expanded(
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
                      Text(
                        address?.locationname ?? "Select Address",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        address?.address ?? "",
                        style: const TextStyle(
                          fontSize:
                              DimensionsResources.FONT_SIZE_1X_EXTRA_SMALL,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_12.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            icon: SvgPicture.asset(
              ImageResource.FILTER_ICON,
              width: DimensionsResources.D_30.w,
              height: DimensionsResources.D_30.h,
              colorFilter: const ColorFilter.mode(
                AppColors.black,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_16.sp),
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
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 10),
              Text("Search groceries...", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // Categories from API via GroceryState — no hardcoded list
  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 40,
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          if (state.categories.isEmpty) {
            return const SizedBox.shrink();
          }

          // Auto-scroll to selected category
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final index = state.categories.indexOf(state.selectedCategory);
            if (index != -1 && _scrollController.hasClients) {
              _scrollController.animateTo(
                index * 120.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          });

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: state.categories.length,
            itemBuilder: (_, index) {
              final categoryName = state.categories[index];
              final isSelected = state.selectedCategory == categoryName;

              return GestureDetector(
                onTap: () {
                  context.read<GroceryBloc>().add(
                    SelectCategoryEvent(categoryName),
                  );
                  if (index < state.categories.length) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.lightBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    categoryName,
                    style: GoogleFonts.inter(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: DimensionsResources.D_14.sp,
                      color: isSelected ? AppColors.white : AppColors.grey,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProducts() {
    return Expanded(
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          // Show loader while fetching from API
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error with retry
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

          if (state.categories.isEmpty) {
            return const Center(child: Text("No products available"));
          }

          return PageView.builder(
            controller: _pageController,
            itemCount: state.categories.length,
            onPageChanged: (index) {
              final categoryName = state.categories[index];
              context.read<GroceryBloc>().add(
                SelectCategoryEvent(categoryName),
              );
            },
            itemBuilder: (context, pageIndex) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    _buildBanner(),
                    SizedBox(height: DimensionsResources.D_10.h),
                    _buildProductGrid(state.filteredItems),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    return CarouselSlider.builder(
      itemCount: ImageResource.banners.length,
      itemBuilder: (context, index, realIndex) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              ImageResource.banners[index],
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        viewportFraction: 1,
      ),
    );
  }

  Widget _buildProductGrid(List<dynamic> items) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 60),
        child: Center(
          child: Text(
            "No products in this category",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    // Handle empty image + fix localhost URL
                    child: item.image.isNotEmpty
                        ? Image.network(
                            fixImageUrl(item.image),
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            ),
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Rs ${item.price}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
