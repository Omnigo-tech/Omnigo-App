import 'package:equatable/equatable.dart';

import '../../../data/models/grocery_category_model.dart';
import '../grocery_data/grocery_model.dart';

class GroceryState extends Equatable {
  final bool isLoading;
  final bool isSearching;
  final String? error;

  final List<GroceryModel> allItems;
  final List<GroceryModel> filteredItems;
  final List<GroceryModel> searchResults;

  final String selectedCategory;

  final List<GrocerySubCategoryModel> categories;

  final List<String> productSuggestions;

  const GroceryState({
    required this.isLoading,
    required this.isSearching,
    required this.error,
    required this.allItems,
    required this.filteredItems,
    required this.searchResults,
    required this.selectedCategory,
    required this.categories,
    required this.productSuggestions,
  });

  factory GroceryState.initial() {
    return const GroceryState(
      isLoading: false,
      isSearching: false,
      error: null,
      allItems: [],
      filteredItems: [],
      searchResults: [],
      selectedCategory: "",
      categories: [],
      productSuggestions: [],
    );
  }

  GroceryState copyWith({
    bool? isLoading,
    bool? isSearching,
    String? error,
    List<GroceryModel>? allItems,
    List<GroceryModel>? filteredItems,
    List<GroceryModel>? searchResults,
    String? selectedCategory,
    List<GrocerySubCategoryModel>? categories,
    List<String>? productSuggestions,
  }) {
    return GroceryState(
      isLoading: isLoading ?? this.isLoading,
      isSearching: isSearching ?? this.isSearching,
      error: error,
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      searchResults: searchResults ?? this.searchResults,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      productSuggestions:
      productSuggestions ?? this.productSuggestions,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSearching,
    error,
    allItems,
    filteredItems,
    searchResults,
    selectedCategory,
    categories,
    productSuggestions,
  ];
}