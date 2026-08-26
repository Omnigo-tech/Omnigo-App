import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/repositories/restaurant_repository.dart';

import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc
    extends Bloc<RestaurantEvent, RestaurantState> {

  final RestaurantRepository repository;

  RestaurantBloc(this.repository)
      : super(RestaurantInitialState()) {

    on<FetchRestaurantDetailsEvent>(
      _onFetchRestaurantDetails,
    );

    on<ChangeCategoryTabEvent>(
      _onChangeCategoryTab,
    );

    on<FetchCategoryProductsEvent>(
      _onFetchCategoryProducts,
    );
  }


  // =====================================================
  // FETCH RESTAURANT
  // API 1 + API 2 + API 3
  // =====================================================

  Future<void> _onFetchRestaurantDetails(
      FetchRestaurantDetailsEvent event,
      Emitter<RestaurantState> emit,
      ) async {

    emit(RestaurantLoadingState());

    try {

      final restaurant =
      await repository.getRestaurantDetails(
        event.restaurantId,
      );


      final categories =
      await repository.getRestaurantCategories(
        event.restaurantId,
      );


      final menuSections =
      await repository.getRestaurantMenu(
        event.restaurantId,
      );


      emit(
        RestaurantLoadedState(
          restaurant: restaurant,
          categories: categories,
          menuSections: menuSections,
        ),
      );

    } catch (e) {

      emit(
        RestaurantErrorState(
          e.toString(),
        ),
      );
    }
  }


  // =====================================================
  // CATEGORY TAB
  // =====================================================

  void _onChangeCategoryTab(
      ChangeCategoryTabEvent event,
      Emitter<RestaurantState> emit,
      ) {

    if (state is! RestaurantLoadedState) {
      return;
    }

    final currentState =
    state as RestaurantLoadedState;

    if (event.selectedIndex < 0 ||
        event.selectedIndex >=
            currentState.categories.length) {
      return;
    }

    emit(
      currentState.copyWith(
        selectedCategoryIndex:
        event.selectedIndex,
      ),
    );
  }


  // =====================================================
  // API 4
  // SEE ALL
  // =====================================================

  Future<void> _onFetchCategoryProducts(
      FetchCategoryProductsEvent event,
      Emitter<RestaurantState> emit,
      ) async {

    if (state is! RestaurantLoadedState) {
      return;
    }

    final currentState =
    state as RestaurantLoadedState;

    emit(
      currentState.copyWith(
        categoryProductsLoading: true,
        selectedCategoryName:
        event.categoryName,
        categoryProducts: [],
      ),
    );

    try {

      final products =
      await repository
          .getProductsByRestaurantCategory(
        restaurantId: currentState.restaurant.id,
        categoryName: event.categoryName,
      );

      if (isClosed) return;

      emit(
        currentState.copyWith(
          categoryProductsLoading: false,
          selectedCategoryName:
          event.categoryName,
          categoryProducts: products,
        ),
      );

    } catch (e) {

      if (isClosed) return;

      emit(
        currentState.copyWith(
          categoryProductsLoading: false,
        ),
      );
    }
  }
}