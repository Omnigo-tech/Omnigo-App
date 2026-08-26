part of 'fast_food_home_bloc.dart';

abstract class FastFoodHomeState {}

class FastFoodInitialState extends FastFoodHomeState {}

class FastFoodLoadingState extends FastFoodHomeState {}

class FastFoodLoadedState extends FastFoodHomeState {
  final int activeTabIndex;
  final int selectedCategoryIndex;

  final List<CategoryModel> categories;
  final List<SubCategoryModel> subCategories;
  final SubCategoryModel? selectedSubCategory;

  final List<ProductModel> products;
  final List<RestaurantModel> restaurants;
  final bool productsLoading;

  // New API Data Lists
  final List<BrandModel> brands;
  final List<HomeChefModel> homeChefs;

  // Existing Data
  final List<PromotionDealModel> promotionDeals;
  final List<FoodItemModel> popularNearMe;
  final List<PopularProductModel> popularItems;
  final List<FoodItemModel> cravingItAgain;
  final List<FastDeliveryRestaurantModel> fastDeliveryRestaurants;
  final List<DailyDealModel> dailyDeals;
  FastFoodLoadedState({
    required this.activeTabIndex,
    required this.selectedCategoryIndex,
    required this.categories,
    required this.subCategories,
    this.selectedSubCategory,
    required this.products,
    required this.restaurants,
    required this.productsLoading,
    required this.brands,
    required this.homeChefs,
    required this.promotionDeals,
    required this.popularNearMe,
    required this.popularItems,
    required this.cravingItAgain,
    required this.fastDeliveryRestaurants,
    required this.dailyDeals,
  });

  FastFoodLoadedState copyWith({
    int? activeTabIndex,
    int? selectedCategoryIndex,
    List<CategoryModel>? categories,
    List<SubCategoryModel>? subCategories,
    SubCategoryModel? selectedSubCategory,
    List<ProductModel>? products,
    List<RestaurantModel>? restaurants,
    bool? productsLoading,
    List<BrandModel>? brands,
    List<HomeChefModel>? homeChefs,
    List<PromotionDealModel>? promotionDeals,
    List<FoodItemModel>? popularNearMe,
    List<PopularProductModel>? popularItems,
    List<FoodItemModel>? cravingItAgain,
    List<FastDeliveryRestaurantModel>? fastDeliveryRestaurants,
    List<DailyDealModel>? dailyDeals,
  }) {
    return FastFoodLoadedState(
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
      products: products ?? this.products,
      restaurants: restaurants ?? this.restaurants,
      productsLoading: productsLoading ?? this.productsLoading,
      brands: brands ?? this.brands,
      homeChefs: homeChefs ?? this.homeChefs,
      promotionDeals: promotionDeals ?? this.promotionDeals,
      popularNearMe: popularNearMe ?? this.popularNearMe,
      popularItems: popularItems ?? this.popularItems,
      cravingItAgain: cravingItAgain ?? this.cravingItAgain,
      fastDeliveryRestaurants: fastDeliveryRestaurants ?? this.fastDeliveryRestaurants,
      dailyDeals: dailyDeals ?? this.dailyDeals,
    );
  }
}

class FastFoodErrorState extends FastFoodHomeState {
  final String message;
  FastFoodErrorState(this.message);
}