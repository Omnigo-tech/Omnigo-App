import 'package:bloc/bloc.dart';

import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/data/datasource/repositories/fast_food_home_repository.dart';

import '../../../data/models/fast_foods_models/category_response_model.dart';
import '../../../data/models/fast_foods_models/daily_deal_model.dart';
import '../../../data/models/fast_foods_models/fast_delivery_restaurant_model.dart';
import '../../../data/models/fast_foods_models/fast_food_category_model.dart';
import '../../../data/models/fast_foods_models/food_category_model.dart';
import '../../../data/models/fast_foods_models/popular_product_model.dart';
import '../../../data/models/fast_foods_models/product_by_category_response_model.dart';
import '../../../data/models/fast_foods_models/brand_model.dart';
import '../../../data/models/fast_foods_models/home_chef_model.dart';
import '../../../data/models/fast_foods_models/promotion_deal_model.dart';

part 'fast_food_home_event.dart';
part 'fast_food_home_state.dart';

class FastFoodHomeBloc
    extends Bloc<FastFoodHomeEvent, FastFoodHomeState> {

  final FastFoodHomeRepository repository;

  FastFoodHomeBloc(this.repository)
      : super(FastFoodInitialState()) {

    on<LoadCategoryDataEvent>(
      _onLoadCategoryData,
    );

    on<SelectMainCategoryEvent>(
      _onSelectMainCategory,
    );

    on<SelectSubCategoryEvent>(
      _onSelectSubCategory,
    );
  }

  // ============================================================
  // LOAD CATEGORIES, BRANDS & HOME CHEFS
  // ============================================================

  Future<void> _onLoadCategoryData(
      LoadCategoryDataEvent event,
      Emitter<FastFoodHomeState> emit,
      ) async {

    emit(FastFoodLoadingState());

    try {

      // --------------------------------------------------------
      // 1. GET CATEGORIES, BRANDS & HOME CHEFS IN PARALLEL
      // --------------------------------------------------------

      final results = await Future.wait([
        repository.getCategories(),
        repository.getRestaurantBrands().catchError((_) => <BrandModel>[]),
        repository.getHomeChefs().catchError((_) => <HomeChefModel>[]),
        repository.getFastDeliveryRestaurants().catchError((_) => <FastDeliveryRestaurantModel>[]),
        repository.getDailyDeals(type: "daily-deal").catchError((_) => <DailyDealModel>[]),
        repository.getPopularProducts(type: "popular").catchError((_) => <PopularProductModel>[]),
        repository.getPromotionDeals()
            .catchError(
              (_) => <PromotionDealModel>[],
        ),// ADD THIS
      ]);

      final categories = results[0] as List<CategoryModel>;
      final brands = results[1] as List<BrandModel>;
      final homeChefs = results[2] as List<HomeChefModel>;
      final fastDeliveryRestaurants = results[3] as List<FastDeliveryRestaurantModel>;
      final dailyDeals= results[4] as List<DailyDealModel>;
      final popularItems = results[5] as List<PopularProductModel>;
      final promotionDeals =
      results[6]
      as List<PromotionDealModel>;// PASS TO STATE

      if (categories.isEmpty) {
        emit(
          FastFoodErrorState(
            'No categories found',
          ),
        );

        return;
      }

      // --------------------------------------------------------
      // 2. FIRST CATEGORY
      // --------------------------------------------------------

      final firstCategory = categories.first;

      // --------------------------------------------------------
      // 3. GET SUBCATEGORIES
      // --------------------------------------------------------

      List<SubCategoryModel> subCategories = [];

      try {
        subCategories = await repository.getSubCategories(
          firstCategory.id,
        );
      } catch (e) {
        subCategories = [];
      }

      // --------------------------------------------------------
      // 4. FIRST SUBCATEGORY
      // --------------------------------------------------------

      SubCategoryModel? selectedSubCategory;

      if (subCategories.isNotEmpty) {
        selectedSubCategory = subCategories.first;
      }

      // --------------------------------------------------------
      // 5. LOAD PRODUCTS
      // --------------------------------------------------------

      List<ProductModel> products = [];
      List<RestaurantModel> restaurants = [];

      if (selectedSubCategory != null) {
        final productResponse = await repository.getProductsByCategory(
          category: firstCategory.categorySlug!,
          subcategory: selectedSubCategory.name,
        );

        products = productResponse.products;
        restaurants = productResponse.restaurants;
      }

      // --------------------------------------------------------
      // 6. EMIT (With Dynamic Brands and Home Chefs)
      // --------------------------------------------------------

      emit(
        FastFoodLoadedState(
          activeTabIndex: 0,
          selectedCategoryIndex: 0,
          categories: categories,
          subCategories: subCategories,
          selectedSubCategory: selectedSubCategory,
          products: products,
          restaurants: restaurants,
          productsLoading: false,

          // Live API Data Integration
          brands: brands,
          homeChefs: homeChefs,

          promotionDeals: promotionDeals,
          popularNearMe: _getPopularNearMe(),
          popularItems: popularItems,
          cravingItAgain: _getCravingItAgain(),
          fastDeliveryRestaurants: fastDeliveryRestaurants,
          dailyDeals: dailyDeals,
        ),
      );

    } catch (e) {
      emit(
        FastFoodErrorState(
          e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // MAIN CATEGORY SELECT
  // ============================================================

  Future<void> _onSelectMainCategory(
      SelectMainCategoryEvent event,
      Emitter<FastFoodHomeState> emit,
      ) async {

    if (state is! FastFoodLoadedState) {
      return;
    }

    final currentState = state as FastFoodLoadedState;

    try {

      // --------------------------------------------------------
      // GET SUBCATEGORIES
      // --------------------------------------------------------

      final subCategories = await repository.getSubCategories(
        event.categoryId,
      );

      // --------------------------------------------------------
      // FIRST SUBCATEGORY
      // --------------------------------------------------------

      SubCategoryModel? selectedSubCategory;

      if (subCategories.isNotEmpty) {
        selectedSubCategory = subCategories.first;
      }

      // --------------------------------------------------------
      // SHOW CATEGORY CHANGE FIRST
      // --------------------------------------------------------

      emit(
        currentState.copyWith(
          activeTabIndex: event.selectedIndex,
          selectedCategoryIndex: 0,
          subCategories: subCategories,
          selectedSubCategory: selectedSubCategory,
          products: [],
          restaurants: [],
          productsLoading: selectedSubCategory != null,
        ),
      );

      // --------------------------------------------------------
      // LOAD PRODUCTS
      // --------------------------------------------------------

      if (selectedSubCategory == null) {
        emit(
          currentState.copyWith(
            activeTabIndex: event.selectedIndex,
            selectedCategoryIndex: 0,
            subCategories: subCategories,
            selectedSubCategory: null,
            products: [],
            restaurants: [],
            productsLoading: false,
          ),
        );

        return;
      }

      final category = currentState.categories[event.selectedIndex];

      final productResponse = await repository.getProductsByCategory(
        category: category.categorySlug!,
        subcategory: selectedSubCategory.name,
      );

      // --------------------------------------------------------
      // FINAL STATE
      // --------------------------------------------------------

      emit(
        currentState.copyWith(
          activeTabIndex: event.selectedIndex,
          selectedCategoryIndex: 0,
          subCategories: subCategories,
          selectedSubCategory: selectedSubCategory,
          products: productResponse.products,
          restaurants: productResponse.restaurants,
          productsLoading: false,
        ),
      );

    } catch (e) {
      emit(
        FastFoodErrorState(
          'Failed to load category data: $e',
        ),
      );
    }
  }

  // ============================================================
  // SUBCATEGORY SELECT
  // ============================================================

  Future<void> _onSelectSubCategory(
      SelectSubCategoryEvent event,
      Emitter<FastFoodHomeState> emit,
      ) async {

    if (state is! FastFoodLoadedState) {
      return;
    }

    final currentState = state as FastFoodLoadedState;

    // ----------------------------------------------------------
    // FIND SELECTED SUBCATEGORY
    // ----------------------------------------------------------

    SubCategoryModel? selectedSubCategory;

    for (final item in currentState.subCategories) {
      if (item.id == event.subCategoryId) {
        selectedSubCategory = item;
        break;
      }
    }

    if (selectedSubCategory == null) {
      return;
    }

    // ----------------------------------------------------------
    // GET CURRENT MAIN CATEGORY
    // ----------------------------------------------------------

    final category = currentState.categories[currentState.activeTabIndex];

    // ----------------------------------------------------------
    // CLEAR OLD PRODUCTS + SHOW LOADING
    // ----------------------------------------------------------

    emit(
      currentState.copyWith(
        selectedCategoryIndex: event.selectedCategoryIndex,
        selectedSubCategory: selectedSubCategory,
        products: [],
        restaurants: [],
        productsLoading: true,
      ),
    );

    try {

      final response = await repository.getProductsByCategory(
        category: category.categorySlug!,
        subcategory: selectedSubCategory.name,
      );

      // --------------------------------------------------------
      // UPDATE PRODUCTS + RESTAURANTS
      // --------------------------------------------------------

      emit(
        currentState.copyWith(
          selectedCategoryIndex: event.selectedCategoryIndex,
          selectedSubCategory: selectedSubCategory,
          products: response.products,
          restaurants: response.restaurants,
          productsLoading: false,
        ),
      );

    } catch (e) {

      emit(
        currentState.copyWith(
          selectedCategoryIndex: event.selectedCategoryIndex,
          selectedSubCategory: selectedSubCategory,
          products: [],
          restaurants: [],
          productsLoading: false,
        ),
      );

      emit(
        FastFoodErrorState(
          'Failed to load products: $e',
        ),
      );
    }
  }

  // ============================================================
  // DUMMY POPULAR NEAR ME
  // ============================================================

  List<FoodItemModel> _getPopularNearMe() {
    return [
      FoodItemModel(
        id: 'pm1',
        name: 'Matko Matki',
        restaurantName: 'Desi food items. In-Store Price.',
        rating: 5.0,
        price: 200.0,
        imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=600',
        restaurantLogo: ImageResource.MATKO_MATKI,
      ),
    ];
  }

  // ============================================================
  // DUMMY CRAVING AGAIN
  // ============================================================

  List<FoodItemModel> _getCravingItAgain() {
    return [
      FoodItemModel(
        id: 'cr1',
        name: 'Special Biryani Platter',
        restaurantName: 'Matko Matki',
        rating: 5.0,
        price: 550.0,
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a7e63c?q=80&w=400',
        restaurantLogo: ImageResource.MATKO_MATKI,
      ),
    ];
  }
}