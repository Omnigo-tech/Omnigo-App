import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryState {
  final List<GroceryModel> allItems;
  final List<GroceryModel> filteredItems;
  final String selectedCategory;

  GroceryState({
    required this.allItems,
    required this.filteredItems,
    required this.selectedCategory,
  });

  factory GroceryState.initial() {
    return GroceryState(
      allItems: [],
      filteredItems: [],
      selectedCategory: "Vegetables",
    );
  }

  GroceryState copyWith({
    List<GroceryModel>? filteredItems,
    String? selectedCategory,
  }) {
    return GroceryState(
      allItems: allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
