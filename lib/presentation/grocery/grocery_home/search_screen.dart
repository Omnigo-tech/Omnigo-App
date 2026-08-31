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
import 'package:grocery_app/widgets/circle_button_widget.dart'; // Import AuthLocalDataSource
import '../../../core/di/service_locator.dart';
import '../../../core/helper/utils/phone_formatter.dart';
import '../../../data/datasource/local/auth_local_data_source.dart';
import '../grocery_bloc/grocery_bloc.dart';
import '../grocery_bloc/grocery_event.dart';
import '../grocery_bloc/grocery_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: DimensionsResources.D_15.h),
            _buildHeader(context),
            _buildSearchField(context),
            Expanded(
              child: isSearching ? _buildResults() : _buildSuggestions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DimensionsResources.D_10.sp,
      ),
      child: Row(
        children: [
          SizedBox(width: DimensionsResources.D_10.w),
          BlocBuilder<AddressBloc, AddressState>(
            builder: (context, state) {
              // 1. First priority: Selected address from AddressBloc state
              String? addressToShow = state.selectedAddress?.address;

              // 2. Fallback: If state address is null or empty, fetch from local storage
              if (addressToShow == null || addressToShow.trim().isEmpty) {
                final localData = sl<AuthLocalDataSource>().getUserLocation();
                addressToShow = localData?['address'];
              }

              // 3. Final default value if local storage is also empty
              if (addressToShow == null || addressToShow.trim().isEmpty) {
                addressToShow = "No Address Selected";
              }

              return Expanded(
                child: Text(
                  addressToShow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: DimensionsResources.FONT_SIZE_SMALL,
                  ),
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
      padding: EdgeInsets.symmetric(horizontal: DimensionsResources.D_18.h,vertical: DimensionsResources.D_10.h ),

      child: Row(
        children: [
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() => isSearching = value.isNotEmpty);
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
          if (isSearching) ...[
            SizedBox(width: DimensionsResources.D_10.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  searchController.clear();
                  isSearching = false;
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

  Widget _buildSuggestions() {
    return BlocBuilder<GroceryBloc, GroceryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.productSuggestions.isEmpty) {
          return const Center(
            child: Text(
              "No suggestions available",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.productSuggestions.map((item) {
                return GestureDetector(
                  onTap: () {
                    searchController.text = item;
                    setState(() => isSearching = true);
                    context.read<GroceryBloc>().add(SearchGroceryEvent(item));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: DimensionsResources.D_14.sp,
                      vertical: DimensionsResources.D_8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.itemBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(color: AppColors.lightText),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResults() {
    return BlocBuilder<GroceryBloc, GroceryState>(
      builder: (context, state) {
        if (state.isSearching) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state.searchResults.isEmpty) {
          return const Center(
            child: Text(
              "Oops! No items found...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: state.searchResults.length,
          itemBuilder: (_, index) {
            final item = state.searchResults[index];
            final imageUrl = item.image;

            return GestureDetector(
              onTap: () {
                final detailItem = GroceryItemModel(
                  id: item.id,
                  name: item.name,
                  image: item.image ?? '',
                  price: item.price,
                  description:
                  item.description ?? "No description available.",
                  weight: item.weight ?? "N/A",
                  belongsTo: item.belongsTo
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
                        child: imageUrl != null && imageUrl.isNotEmpty
                            ? Image.network(
                          ImageUrl.fixImageUrl(imageUrl),
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                              size: 40,
                            );
                          },
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
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.lightText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rs ${item.price}",
                          style: const TextStyle(
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
                              image: item.image ?? '',
                              price: item.price,
                              description:
                              item.description ??
                                  "No description available.",
                              weight: item.weight ?? "N/A",
                                belongsTo: item.belongsTo

                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<GroceryDetailBloc>(),
                                  child: DetailScreen(
                                    item: detailItem,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}