import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';
import '../grocery_bloc/grocery_bloc.dart';
import '../grocery_bloc/grocery_event.dart';
import '../grocery_bloc/grocery_state.dart';

class FilterBottomSheet extends StatefulWidget {
  final int flag;
  const FilterBottomSheet({super.key, required this.flag});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedCategory;
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: DimensionsResources.D_770.h,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 6.h),
            const Text("Sort", style: TextStyle(fontWeight: FontWeight.w500)),
            _buildCheckboxes(),
            SizedBox(height: 16.h),
            const Text(
              "Categories",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            // Categories from API via BlocBuilder
            Expanded(child: _buildCategorySections()),
            _buildApplyButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        const Text(
          "Filters",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = null;
              selectedItem = null;
            });
          },
          child: const Text(
            "Clear all",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxes() {
    final options = [
      {"label": "Popular", "icon": Icons.trending_up},
      {"label": "Discounted", "icon": Icons.local_offer_outlined},
      {"label": "Vegetarian", "icon": Icons.favorite_border},
      {"label": "Vegan", "icon": Icons.spa_outlined},
      {"label": "Gluten-free", "icon": Icons.thumb_up_outlined},
    ];

    return Column(
      children: options.map((item) {
        return SizedBox(
          height: 35.h,
          child: ListTile(
            dense: true,
            title: Text(
              item["label"] as String,
              style: const TextStyle(fontSize: 14),
            ),
            leading: Icon(
              item["icon"] as IconData,
              size: 20,
              color: Colors.grey[700],
            ),
            trailing: SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: false,
                onChanged: (_) {},
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Categories come from GroceryState (extracted from API products in bloc)

  Widget _buildCategorySections() {
    return BlocBuilder<GroceryBloc, GroceryState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.allItems.isEmpty) {
          return const Center(child: Text("No products available"));
        }

        // Group products by category
        Map<String, List<String>> groupedItems = {};

        for (var product in state.allItems) {
          final category = product.category;

          if (!groupedItems.containsKey(category)) {
            groupedItems[category] = [];
          }

          // Add only unique items
          if (!groupedItems[category]!.contains(product.name)) {
            groupedItems[category]!.add(product.name);
          }
        }

        return ListView(
          children: groupedItems.entries.map((entry) {
            String category = entry.key;
            List<String> items = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category title
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Items under category
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((item) {
                    final isSelected = selectedItem == item;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                          selectedItem = item;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color.fromARGB(255, 186, 227, 241)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20.r),
                          border: isSelected
                              ? Border.all(
                                  color: Color.fromARGB(255, 79, 157, 212),
                                  width: 1.5.w,
                                )
                              : null,
                        ),
                        child: Text(
                          item,
                          style: TextStyle(
                            color: isSelected
                                ? Color.fromARGB(255, 61, 147, 208)
                                : AppColors.lightText,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            context.read<GroceryBloc>().add(
              ApplyFilterEvent(category: selectedCategory, item: selectedItem),
            );
            if (widget.flag == 2) {
              Navigator.pop(context);
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.homeBackground,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: const Text(
            "Apply Filters",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
