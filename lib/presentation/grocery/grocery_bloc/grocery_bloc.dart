import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/repositories/glocery_data.dart';
import '../grocery_data/grocery_model.dart';
import 'grocery_event.dart';
import 'grocery_state.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  final GroceryRepository repository;

  bool _hasLoadedOnce = false;
  GroceryBloc(this.repository) : super(GroceryState.initial()) {
    on<LoadGroceryEvent>(_loadData);
    on<SearchGroceryEvent>(_searchItems);
    on<SelectCategoryEvent>(_filterCategory);
    on<ApplyFilterEvent>(_applyFilters);
    on<ApplyItemFilterEvent>(_applyItemFilter);
    on<UpdateFavoriteStatusEvent>(_updateFavoriteStatus);
  }

  Future<void> _loadData(
      LoadGroceryEvent event,
      Emitter<GroceryState> emit,
      ) async {
    // Agar data already load ho chuka hai aur ye forced refresh nahi hai,
    // to dobara API calls mat karo (See all pe click karne se yahi duplicate calls rukengi)
    if (_hasLoadedOnce && state.allItems.isNotEmpty && !event.forceRefresh) {
      // Sirf category switch/selection handle kar do, calls nahi
      if (event.initialCategory != null && event.initialCategory!.isNotEmpty) {
        final requested = event.initialCategory!.trim().toLowerCase();

        final matchedCategory = state.categories.where(
              (category) =>
          category.name.toLowerCase() == requested ||
              category.slug.toLowerCase() == requested,
        );

        final selected =
        matchedCategory.isNotEmpty ? matchedCategory.first.name : "";

        final filtered = state.allItems.where((item) {
          return item.category.trim().toLowerCase() == selected.toLowerCase();
        }).toList();

        emit(
          state.copyWith(
            selectedCategory: selected,
            filteredItems: filtered,
          ),
        );
      } else if (event.showAll) {
        final firstCategory = state.categories.isNotEmpty
            ? state.categories.first.name
            : "";

        emit(
          state.copyWith(
            selectedCategory: firstCategory,
            filteredItems: state.allItems,
          ),
        );
      }
      return;
    }

    emit(state.copyWith(isLoading: true, error: null));

    try {
      final categories = await repository.getGroceryCategories();

      // Sab categories ke products ek sath (parallel) fetch karo
      // Future.wait total time ko sabse slow request jitna rakhta hai,
      // sequential loop ki tarah sab time ka jama nahi
      final results = await Future.wait(
        categories.map(
              (category) => repository
              .getProducts(category: category.slug)
              .catchError((_) => <GroceryModel>[]), // 1 category fail ho to baqi na rukein
        ),
      );

      final List<GroceryModel> products = results.expand((list) => list).toList();

      final uniqueProducts = <String, GroceryModel>{};
      for (final product in products) {
        uniqueProducts[product.id] = product;
      }
      final allProducts = uniqueProducts.values.toList();

      final suggestions = allProducts
          .map((item) => item.name.trim())
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      String selected;
      List<GroceryModel> filtered;

      if (event.showAll) {
        // See All par first category default select/highlight hogi
        selected = categories.isNotEmpty
            ? categories.first.name
            : "";
        filtered = allProducts;
      } else if (event.initialCategory != null &&
          event.initialCategory!.isNotEmpty) {
        final requested = event.initialCategory!.trim().toLowerCase();

        final matchedCategory = categories.where(
              (category) =>
          category.name.toLowerCase() == requested ||
              category.slug.toLowerCase() == requested,
        );

        selected =
        matchedCategory.isNotEmpty ? matchedCategory.first.name : "";

        filtered = allProducts.where((item) {
          return item.category.trim().toLowerCase() == selected.toLowerCase();
        }).toList();
      } else {
        selected = categories.isNotEmpty ? categories.first.name : "";

        filtered = allProducts.where((item) {
          return item.category.trim().toLowerCase() == selected.toLowerCase();
        }).toList();
      }

      _hasLoadedOnce = true;

      emit(
        state.copyWith(
          isLoading: false,
          allItems: allProducts,
          filteredItems: filtered,
          categories: categories,
          productSuggestions: suggestions,
          selectedCategory: selected,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _searchItems(
      SearchGroceryEvent event,
      Emitter<GroceryState> emit,
      ) async {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(state.copyWith(isSearching: false, searchResults: []));
      return;
    }

    emit(state.copyWith(isSearching: true));

    final results = state.allItems.where((item) {
      return item.name.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(isSearching: false, searchResults: results));
  }

  void _filterCategory(
      SelectCategoryEvent event,
      Emitter<GroceryState> emit,
      ) {
    if (event.category.isEmpty) {
      emit(state.copyWith(filteredItems: state.allItems, selectedCategory: ""));
      return;
    }

    final filtered = state.allItems.where((item) {
      return item.category.trim().toLowerCase() ==
          event.category.trim().toLowerCase();
    }).toList();

    emit(
      state.copyWith(filteredItems: filtered, selectedCategory: event.category),
    );
  }

  void _applyFilters(
      ApplyFilterEvent event,
      Emitter<GroceryState> emit,
      ) {
    List<GroceryModel> filtered = List.from(state.allItems);

    final selectedCategory =
        event.category?.trim() ?? '';

    final selectedItem =
        event.item?.trim() ?? '';

    if (selectedCategory.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.category.trim().toLowerCase() ==
            selectedCategory.toLowerCase();
      }).toList();
    }

    if (selectedItem.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.trim().toLowerCase() ==
            selectedItem.toLowerCase();
      }).toList();
    }

    emit(
      state.copyWith(
        filteredItems: filtered,

        // Category selected hai to main category bar mein bhi highlight hogi
        selectedCategory: selectedCategory,
        error: null,
      ),
    );
  }

  void _applyItemFilter(
      ApplyItemFilterEvent event,
      Emitter<GroceryState> emit,
      ) {
    final filtered = state.allItems.where((item) {
      return item.name.toLowerCase() == event.selectedItem.toLowerCase();
    }).toList();

    emit(state.copyWith(filteredItems: filtered));
  }

  void _updateFavoriteStatus(
      UpdateFavoriteStatusEvent event,
      Emitter<GroceryState> emit,
      ) {
    final updatedAllItems = state.allItems.map((item) {
      if (item.id == event.productId) {
        return item.copyWith(isFavourite: event.isFavourite);
      }
      return item;
    }).toList();

    final updatedFilteredItems = state.filteredItems.map((item) {
      if (item.id == event.productId) {
        return item.copyWith(isFavourite: event.isFavourite);
      }
      return item;
    }).toList();

    final updatedSearchResults = state.searchResults.map((item) {
      if (item.id == event.productId) {
        return item.copyWith(isFavourite: event.isFavourite);
      }
      return item;
    }).toList();

    emit(
      state.copyWith(
        allItems: updatedAllItems,
        filteredItems: updatedFilteredItems,
        searchResults: updatedSearchResults,
      ),
    );
  }
}