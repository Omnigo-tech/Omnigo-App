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
    return SafeArea(child: GroceryView());
  }
}

class GroceryView extends StatefulWidget {
  const GroceryView({super.key});

  @override
  State<GroceryView> createState() => _GroceryViewState();
}

class _GroceryViewState extends State<GroceryView> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  final List<Map<String, String>> categories = const [
    {"name": "Vegetables", "image": ImageResource.VEGETABLE_IMAGE},
    {"name": "Fruits", "image": ImageResource.FRUIT_IMAGE},
    {"name": "Meat", "image": ImageResource.MEAT_IMG},
    {"name": "Drinks", "image": ImageResource.DRINK_IMG},
    {"name": "Dairy", "image": ImageResource.BYKERY_IMG},
    {"name": "Eggs", "image": ImageResource.Egg},
    {"name": "Breads", "image": ImageResource.BREAD_IMG},
    {"name": "Spices", "image": ImageResource.SPICES_IMG},
    {"name": "Oil&Ghee", "image": ImageResource.OIL_IMG},
    {"name": "Rice&Dall", "image": ImageResource.DALLS_IMG},
    {"name": "Sauces&Pastes", "image": ImageResource.SAUCE_IMG},
    {"name": "Salts", "image": ImageResource.SALT_IMG},
    {"name": "Baking&Desserts", "image": ImageResource.BAKING_IMG},
  ];

  // ✅ Fix #3: Helper to replace localhost with actual IP
  String fixImageUrl(String url) {
    return url.replaceAll('localhost', '192.168.1.106');
  }

  @override
  void initState() {
    super.initState();
    // ✅ Fix #7: Trigger LoadGroceryEvent when screen loads
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

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 40,
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollToSelectedCategory(state.selectedCategory);
          });
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (_, index) {
              final category = categories[index];
              final String categoryName = category["name"]!;
              final isSelected = state.selectedCategory == categoryName;
              return GestureDetector(
                onTap: () {
                  context.read<GroceryBloc>().add(
                    SelectCategoryEvent(categoryName),
                  );
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                  );
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
                  child: Row(
                    children: [
                      Text(
                        categoryName,
                        style: GoogleFonts.inter(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: DimensionsResources.D_14.sp,
                          color: isSelected ? AppColors.white : AppColors.grey,
                        ),
                      ),
                      SizedBox(width: DimensionsResources.D_4.w),
                      Image.asset(
                        category["image"]!,
                        width: DimensionsResources.D_32.w,
                        height: DimensionsResources.D_32.h,
                        fit: BoxFit.contain,
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

  Widget _buildProducts() {
    return Expanded(
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          // ✅ Fix #6: Show loading indicator
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Fix #6: Show error message
          if (state.error != null && state.error!.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    "Something went wrong",
                    style: const TextStyle(fontWeight: FontWeight.bold),
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

          return PageView.builder(
            controller: _pageController,
            itemCount: categories.length,
            onPageChanged: (index) {
              final categoryName = categories[index]["name"]!;
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
            "No products found in this category",
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
                    // ✅ Fix #2: Handle empty image URL
                    child: item.image.isNotEmpty
                        ? Image.network(
                            fixImageUrl(item.image), // ✅ Fix #3
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
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

  void scrollToSelectedCategory(String selectedCategory) {
    final index = categories.indexWhere(
      (cat) => cat["name"] == selectedCategory,
    );
    if (index != -1 && _scrollController.hasClients) {
      _scrollController.animateTo(
        index * 110,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}

/*import 'package:carousel_slider/carousel_slider.dart';
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
    return SafeArea(child: GroceryView());
  }
}

class GroceryView extends StatefulWidget {
  const GroceryView({super.key});

  @override
  State<GroceryView> createState() => _GroceryViewState();
}

class _GroceryViewState extends State<GroceryView> {
  @override
  void initState() {
    super.initState();
    context.read<GroceryBloc>().add(LoadGroceryEvent());
  }

  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();

  final List<Map<String, String>> categories = const [
    {"name": "Vegetables", "image": ImageResource.VEGETABLE_IMAGE},
    {"name": "Fruits", "image": ImageResource.FRUIT_IMAGE},
    {"name": "Meat", "image": ImageResource.MEAT_IMG},
    {"name": "Drinks", "image": ImageResource.DRINK_IMG},
    {"name": "Dairy", "image": ImageResource.BYKERY_IMG},
    {"name": "Eggs", "image": ImageResource.Egg},
    {"name": "Breads", "image": ImageResource.BREAD_IMG},
    {"name": "Spices", "image": ImageResource.SPICES_IMG},
    {"name": "Oil&Ghee", "image": ImageResource.OIL_IMG},
    {"name": "Rice&Dall", "image": ImageResource.DALLS_IMG},
    {"name": "Sauces&Pastes", "image": ImageResource.SAUCE_IMG},
    {"name": "Salts", "image": ImageResource.SALT_IMG},
    {"name": "Baking&Desserts", "image": ImageResource.BAKING_IMG},
  ];

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
                  child: Container(
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

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 40,
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollToSelectedCategory(state.selectedCategory);
          });
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (_, index) {
              final category = categories[index];
              final String categoryName = category["name"]!;
              final isSelected = state.selectedCategory == categoryName;
              return GestureDetector(
                onTap: () {
                  context.read<GroceryBloc>().add(
                    SelectCategoryEvent(categoryName),
                  );
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                  );
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
                  child: Row(
                    children: [
                      Text(
                        categoryName,
                        style: GoogleFonts.inter(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: DimensionsResources.D_14.sp,
                          color: isSelected ? AppColors.white : AppColors.grey,
                        ),
                      ),
                      SizedBox(width: DimensionsResources.D_4.w),
                      Image.asset(
                        category["image"]!,
                        width: DimensionsResources.D_32.w,
                        height: DimensionsResources.D_32.h,
                        fit: BoxFit.contain,
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

  Widget _buildProducts() {
    return Expanded(
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.error != null && state.error!.isNotEmpty) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return PageView.builder(
            controller: _pageController,
            itemCount: categories.length,
            onPageChanged: (index) {
              final categoryName = categories[index]["name"]!;
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
                    child: item.image.isNotEmpty
                        ? Image.network(
                            fixImageUrl(item.image),
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(Icons.image),
                          )
                        : const Icon(
                            Icons.image,
                            size: 40,
                            color: Colors.grey,
                          ), //Image.asset(item.image, fit: BoxFit.contain),
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

  void scrollToSelectedCategory(String selectedCategory) {
    final index = categories.indexWhere(
      (cat) => cat["name"] == selectedCategory,
    );
    if (index != -1 && _scrollController.hasClients) {
      _scrollController.animateTo(
        index * 110,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  String fixImageUrl(String url) {
    return url.replaceAll('localhost', '192.168.1.106');
  }
}*/
