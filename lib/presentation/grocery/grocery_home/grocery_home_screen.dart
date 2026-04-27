import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/data/models/grocery-item.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/screens/user_interface/details/grocery_details.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/filter_bottom_sheet.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/search_screen.dart';
import 'package:grocery_app/presentation/screens/user_interface/my_cart/my_cart_screen.dart';
import '../grocery_bloc/grocery_bloc.dart';
import '../grocery_bloc/grocery_event.dart';
import '../grocery_bloc/grocery_state.dart';

class GroceryHomeScreen extends StatelessWidget {
  final String nameCategories;
   GroceryHomeScreen({super.key, required this.nameCategories});

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: GroceryView());
  }
}

class GroceryView extends StatelessWidget {
  GroceryView({super.key});

  final List<Map<String, String>> categories = const [
    {
      "name": "Vegetables",
      "image": ImageResource.VEGETABLE_IMAGE,
    },
    {"name": "Fruits", "image": ImageResource.FRUIT_IMAGE},
    {"name": "Meat", "image": ImageResource.MEAT_IMG},
    {"name": "Drinks", "image": ImageResource.DRINK_IMG},
    {"name": "Dairy", "image": ImageResource.BYKERY_IMG},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            //SizedBox(height: DimensionsResources.D_10),
            _buildSearchBar(context),
            //SizedBox(height: DimensionsResources.D_12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${StringResources.categories}",
                  style: TextStyle(
                    fontSize: DimensionsResources.FONT_SIZE_MEDIUM,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => BlocProvider.value(
                        value: context.read<GroceryBloc>(),
                        child: const FilterBottomSheet(flag: 1),
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    ImageResource.FILTER_ICON,
                    width: DimensionsResources.D_36.w,
                    height: DimensionsResources.D_36.h,
                  ),
                ),
              ],
            ),
            //SizedBox(height: DimensionsResources.D_10),
            _buildCategories(context),
            //SizedBox(height: DimensionsResources.D_10),
            _buildProducts(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DimensionsResources.D_16.sp,
        vertical: DimensionsResources.D_10.h,
      ),
      child: Row(
        children: [
          const SizedBox(width: 6),
          const Icon(Icons.location_on_outlined, color: Colors.blue),
          const SizedBox(width: 6),
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              final address = state.selectedAddress;
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address?.locationname ?? "Select Address",
                      style: TextStyle(fontWeight: .bold),
                    ),
                    Text(
                      address?.address ?? "",
                      style: TextStyle(
                        fontSize: DimensionsResources.FONT_SIZE_1X_EXTRA_SMALL,
                      ),
                    ),
                  ],
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
          child: Row(
            children: const [
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
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (_, index) {
              final category = categories[index];
              final String categoryName = category["name"]!;
              final String categoryImge = category["image"]!;
              final isSelected = state.selectedCategory == categoryName;
              return GestureDetector(
                onTap: () {
                  context.read<GroceryBloc>().add(
                    SelectCategoryEvent(categoryName),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Text(
                        categoryName,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: DimensionsResources.D_14.sp,
                          color: isSelected
                              ? AppColors.darkGreen
                              : AppColors.grey,
                        ),
                      ),
                      SizedBox(width: DimensionsResources.D_4.w),
                      Image.asset(
                        categoryImge,
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
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            CarouselSlider.builder(
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
            ),
            SizedBox(height: DimensionsResources.D_10.h),
            BlocBuilder<GroceryBloc, GroceryState>(
              builder: (context, state) {
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
                  itemCount: state.filteredItems.length,
                  itemBuilder: (_, index) {
                    final item = state.filteredItems[index];

                    return GestureDetector(
                      onTap: () {
                        final detailItem = GroceryItemModel(
                          id: item.id,
                          name: item.name,
                          image: item.image,
                          price: item.price,
                          description:
                              item.description ?? "No description available.",
                          weight: item.weight ?? "N/A",
                        );

                        // Use the existing GroceryDetailBloc by passing it to the new screen
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
                                child: Image.asset(
                                  item.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.name,
                              style: TextStyle(
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
