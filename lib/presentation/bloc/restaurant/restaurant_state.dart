import 'package:equatable/equatable.dart';

import '../../../data/models/fast_foods_models/restaurant_model.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}


// =====================================================
// INITIAL
// =====================================================

class RestaurantInitialState extends RestaurantState {}


// =====================================================
// LOADING
// =====================================================

class RestaurantLoadingState extends RestaurantState {}


// =====================================================
// LOADED
// =====================================================

class RestaurantLoadedState extends RestaurantState {
  final RestaurantModel restaurant;

  final List<RestaurantCategoryModel> categories;

  final List<FoodCategorySection> menuSections;

  final int selectedCategoryIndex;

  final bool categoryProductsLoading;

  final String? selectedCategoryName;

  final List<RestaurantFoodItemModel>
  categoryProducts;

  const RestaurantLoadedState({
    required this.restaurant,
    required this.categories,
    required this.menuSections,
    this.selectedCategoryIndex = 0,
    this.categoryProductsLoading = false,
    this.selectedCategoryName,
    this.categoryProducts = const [],
  });

  RestaurantLoadedState copyWith({
    RestaurantModel? restaurant,
    List<RestaurantCategoryModel>? categories,
    List<FoodCategorySection>? menuSections,
    int? selectedCategoryIndex,
    bool? categoryProductsLoading,
    String? selectedCategoryName,
    List<RestaurantFoodItemModel>? categoryProducts,
  }) {
    return RestaurantLoadedState(
      restaurant: restaurant ?? this.restaurant,
      categories: categories ?? this.categories,
      menuSections: menuSections ?? this.menuSections,
      selectedCategoryIndex:
      selectedCategoryIndex ??
          this.selectedCategoryIndex,
      categoryProductsLoading:
      categoryProductsLoading ??
          this.categoryProductsLoading,
      selectedCategoryName:
      selectedCategoryName ??
          this.selectedCategoryName,
      categoryProducts:
      categoryProducts ??
          this.categoryProducts,
    );
  }

  @override
  List<Object?> get props => [
    restaurant,
    categories,
    menuSections,
    selectedCategoryIndex,
    categoryProductsLoading,
    selectedCategoryName,
    categoryProducts,
  ];
}


// =====================================================
// ERROR
// =====================================================

class RestaurantErrorState extends RestaurantState {
  final String message;

  const RestaurantErrorState(
      this.message,
      );

  @override
  List<Object?> get props => [message];
}