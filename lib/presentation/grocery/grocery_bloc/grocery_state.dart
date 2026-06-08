import 'package:equatable/equatable.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryState extends Equatable {
  final bool isLoading;
  final String? error;

  final List<GroceryModel> allItems;
  final List<GroceryModel> filteredItems;
  final String selectedCategory;

  const GroceryState({
    required this.isLoading,
    required this.error,
    required this.allItems,
    required this.filteredItems,
    required this.selectedCategory,
  });

  factory GroceryState.initial() {
    return const GroceryState(
      isLoading: false,
      error: null, // ✅ Fix #5: use null instead of ""
      allItems: [],
      filteredItems: [],
      selectedCategory: "Vegetables",
    );
  }

  GroceryState copyWith({
    bool? isLoading,
    String? error,
    List<GroceryModel>? allItems,
    List<GroceryModel>? filteredItems,
    String? selectedCategory,
  }) {
    return GroceryState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // ✅ Fix: allow setting error to null
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  // ✅ Fix #5: Added isLoading and error to props
  List<Object?> get props => [
    isLoading,
    error,
    allItems,
    filteredItems,
    selectedCategory,
  ];
}













/*import 'package:equatable/equatable.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryState extends Equatable {
  final bool isLoading;
  final String? error;

  final List<GroceryModel> allItems;
  final List<GroceryModel> filteredItems;
  final String selectedCategory;

  const GroceryState({
    required this.isLoading,
    required this.error,
    required this.allItems,
    required this.filteredItems,
    required this.selectedCategory,
  });

  factory GroceryState.initial() {
    return const GroceryState(
      isLoading: false,
      error: "",
      allItems: [],
      filteredItems: [],
      selectedCategory: "Vegetables",
    );
  }

  GroceryState copyWith({
    bool? isLoading,
    String? error,
    List<GroceryModel>? allItems,
    List<GroceryModel>? filteredItems,
    String? selectedCategory,
  }) {
    return GroceryState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    allItems,
    filteredItems,
    selectedCategory,
  ];
}*/

