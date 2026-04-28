import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/sizes.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/data/models/grocery-item.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/filter_bottom_sheet.dart';
import 'package:grocery_app/presentation/screens/user_interface/details/grocery_details.dart';
import 'package:grocery_app/widgets/circle_button_widget.dart';
import '../grocery_bloc/grocery_bloc.dart';
import '../grocery_bloc/grocery_event.dart';
import '../grocery_bloc/grocery_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isTrue = false;
  String? selectedItem;
  final List<String> data = [
    "Ginger",
    "Carrot",
    "Lemon",
    "Onion",
    "Potato",
    "Tomato",
    "Garlic",
    "Peas",
    "Beans",
    "Pumpkin",
    "Apple",
    "Banana",
    "Mango",
    "Orange",
    "Peach",
    "Cherry",
    "Strawberry",
    "Papaya",
    "Guava",
    "Pear",
    "Chicken",
    "Beef",
    "Mutton",
    "Fish",
    "Prawns",
    "Turkey",
    "Duck",
    "Lamb",
    "Sausage",
    "Ham",
    "Kebab",
    "Juice",
    "Tea",
    "Lassi",
    "Iced Tea",
    "Green Tea",
    "Black Coffee",
    "Lemonade",
    "Milk",
    "Cheese",
    "Yogurt",
    "Cream",
    "Paneer",
    "Custard",
    "Ghee",
    "Flavored Milk",
    "Cheddar",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: DimensionsResources.D_25.h),
            _buildHeader(context),
            _buildSearchField(context),
            isTrue == false
                ? Expanded(child: _buildCategorySections())
                : _buildResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DimensionsResources.D_10.sp,
        vertical: DimensionsResources.D_5.h,
      ),
      child: Row(
        children: [
          SizedBox(width: DimensionsResources.D_10.w),
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              final address = state.selectedAddress;
              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address?.address ?? "",
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: DimensionsResources.FONT_SIZE_SMALL,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<GroceryBloc>(),
                  child: const FilterBottomSheet(flag: 2),
                ),
              );
            },
            icon: SvgPicture.asset(
              ImageResource.FILTER_ICON,
              width: DimensionsResources.D_40.w,
              height: DimensionsResources.D_40.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(DimensionsResources.D_10.h),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() => isTrue = true);
                } else {
                  setState(() => isTrue = false);
                }
                context.read<GroceryBloc>().add(SearchGroceryEvent(value));
              },
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search groceries...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: DimensionsResources.D_0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    DimensionsResources.RADIUS_DEFAULT.r,
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          if (isTrue) ...[
            SizedBox(width: DimensionsResources.D_10.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  searchController.clear();
                  isTrue = false;
                });

                context.read<GroceryBloc>().add(SearchGroceryEvent(""));
              },
              child: Text(
                StringResources.cancel,
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Expanded(
      child: BlocBuilder<GroceryBloc, GroceryState>(
        builder: (context, state) {
          if (state.filteredItems.isEmpty) {
            return const Center(
              child: Text(
                "Oops! No items found...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.filteredItems.length,
            itemBuilder: (_, index) {
              final item = state.filteredItems[index];

              return Container(
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
                        child: Image.asset(item.image, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightText,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rs ${item.price}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        CustomCircleBtn(
                          icon: Icons.add,
                          isAdd: true,
                          size: 30,
                          borderRadius: 10,
                          onTap: () {
                            final detailItem = GroceryItemModel(
                              id: item.id,
                              name: item.name,
                              image: item.image,
                              price: item.price,
                              description:
                                  item.description ??
                                  "No description available.",
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
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCategorySections() {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: data.map((item) {
            final isSelected = selectedItem == item;

            return GestureDetector(
              onTap: () {
                setState(() {
                  isTrue = true;
                  selectedItem = item;
                  searchController.text = selectedItem!;
                });
                context.read<GroceryBloc>().add(
                  SearchGroceryEvent(selectedItem!),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: DimensionsResources.D_14.sp,
                  vertical: DimensionsResources.D_8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green[100]
                      : AppColors.itemBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? Colors.green : AppColors.lightText,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
