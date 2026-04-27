import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/presentation/grocery/grocery_home/grocery_home_screen.dart';
import '../grocery_bloc/grocery_bloc.dart';
import '../grocery_bloc/grocery_event.dart';

class FilterBottomSheet extends StatefulWidget {
  final int flag;
  const FilterBottomSheet({super.key, required this.flag});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? selectedItem;

  final Map<String, List<String>> data = {
    "Vegetables": [
      "Ginger",
      "Carrot",
      "Lemon",
      "Onion",
      "Potato",
      "Tomato",
      "Garlic",
      "Spinach",
      "Cabbage",
      "Peas",
      "Beans",
      "Pumpkin",
      "Radish",
      "Turnip",
      "Capsicum",
    ],
    "Fruits": [
      "Apple",
      "Banana",
      "Mango",
      "Orange",
      "Grapes",
      "Pineapple",
      "Peach",
      "Cherry",
      "Strawberry",
      "Watermelon",
      "Papaya",
      "Guava",
      "Pear",
      "Kiwi",
      "Plum",
    ],
    "Meat": [
      "Chicken",
      "Beef",
      "Mutton",
      "Fish",
      "Prawns",
      "Turkey",
      "Duck",
      "Lamb",
      "Minced Meat",
      "Sausage",
      "Steak",
      "Salami",
      "Bacon",
      "Ham",
      "Kebab",
    ],
    "Drinks": [
      "Juice",
      "Soda",
      "Milkshake",
      "Tea",
      "Coffee",
      "Lassi",
      "Energy Drink",
      "Water",
      "Smoothie",
      "Cold Drink",
      "Iced Tea",
      "Hot Chocolate",
      "Green Tea",
      "Black Coffee",
      "Lemonade",
    ],
    "Dairy": [
      "Milk",
      "Cheese",
      "Butter",
      "Yogurt",
      "Cream",
      "Ice Cream",
      "Paneer",
      "Custard",
      "Ghee",
      "Condensed Milk",
      "Flavored Milk",
      "Kefir",
      "Milk Powder",
      "Whipped Cream",
      "Cheddar",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: DimensionsResources
            .D_770
            .h, //MediaQuery.of(context).size.height * 0.95,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            //const SizedBox(height: 10),
            Text("Sort", style: TextStyle(fontWeight: FontWeight.w500)),
            _buildCheckboxes(),
            const SizedBox(height: 30),
            Expanded(child: _buildCategorySections()),
            _buildApplyButton(context),
          ],
        ),
      ),
    );
  }

  // 🔷 HEADER
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        Text(
          "Filters",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedItem = null;
            });
          },
          child: Text(
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
      {"label": "Popular on Flink", "icon": Icons.trending_up},
      {"label": "Discounted", "icon": Icons.local_offer_outlined},
      {"label": "Vegitarian", "icon": Icons.favorite_border},
      {"label": "Vegan", "icon": Icons.spa_outlined},
      {"label": "Gluten-free", "icon": Icons.thumb_up_outlined},
    ];

    return Column(
      children: options.map((item) {
        return SizedBox(
          height: 35,
          child: ListTile(
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

  Widget _buildCategorySections() {
    return ListView(
      children: data.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: entry.value.map((item) {
                final isSelected = selectedItem == item;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedItem = item;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green[100] : Colors.grey[200],
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

            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return SizedBox(
      width: double.infinity.w,
      child: ElevatedButton(
        onPressed: () {
          if (selectedItem != null) {
            context.read<GroceryBloc>().add(
              ApplyItemFilterEvent(selectedItem!),
            );
            if (widget.flag == 2) {
              Navigator.pop(context);
            }
          }
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.homeBackground,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Apply Filters",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
