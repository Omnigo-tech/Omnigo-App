import 'package:equatable/equatable.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryState extends Equatable {
  final List<GroceryModel> allItems;
  final List<GroceryModel> filteredItems;
  final String selectedCategory;

  const GroceryState({
    required this.allItems,
    required this.filteredItems,
    required this.selectedCategory,
  });

  factory GroceryState.initial() {
    return const GroceryState(
      allItems: [],
      filteredItems: [],
      selectedCategory: "Vegetables",
    );
  }

  GroceryState copyWith({
    List<GroceryModel>? allItems,
    List<GroceryModel>? filteredItems,
    String? selectedCategory,
  }) {
    return GroceryState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [allItems, filteredItems, selectedCategory];
}
