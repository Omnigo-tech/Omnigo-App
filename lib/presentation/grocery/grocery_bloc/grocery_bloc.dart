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
  }

  Future<void> _loadData(
      LoadGroceryEvent event,
      Emitter<GroceryState> emit,
      ) async {
    emit(state.copyWith(
      isLoading: true,
      error: null,
    ));

    try {
      // 1. Grocery categories fetch karo
      final categories = await repository.getGroceryCategories();

      // 2. Har category ke products fetch karo
      final List<GroceryModel> products = [];

      for (final category in categories) {
        try {
          final categoryProducts = await repository.getProducts(
            category: category.slug,
          );

          products.addAll(categoryProducts);
        } catch (_) {
          // Agar ek category fail ho to baqi categories continue rahengi
        }
      }

      // 3. Duplicate products remove karo
      final uniqueProducts = <String, GroceryModel>{};

      for (final product in products) {
        uniqueProducts[product.id] = product;
      }

      final allProducts = uniqueProducts.values.toList();

      // 4. Search suggestions
      final suggestions = allProducts
          .map((item) => item.name.trim())
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList()
        ..sort();

      String selected;
      List<GroceryModel> filtered;

      if (event.showAll) {
        selected = "";
        filtered = allProducts;
      } else if (event.initialCategory != null &&
          event.initialCategory!.isNotEmpty) {
        final requested =
        event.initialCategory!.trim().toLowerCase();

        final matchedCategory = categories.where(
              (category) =>
          category.name.toLowerCase() == requested ||
              category.slug.toLowerCase() == requested,
        );

        selected = matchedCategory.isNotEmpty
            ? matchedCategory.first.name
            : "";

        filtered = allProducts.where((item) {
          return item.category.trim().toLowerCase() ==
              selected.toLowerCase();
        }).toList();
      } else if (_hasLoadedOnce &&
          state.selectedCategory.isNotEmpty) {
        selected = state.selectedCategory;

        filtered = allProducts.where((item) {
          return item.category.trim().toLowerCase() ==
              selected.toLowerCase();
        }).toList();
      } else {
        selected = categories.isNotEmpty
            ? categories.first.name
            : "";

        filtered = allProducts.where((item) {
          return item.category.trim().toLowerCase() ==
              selected.toLowerCase();
        }).toList();
      }

      _hasLoadedOnce = true;

      emit(state.copyWith(
        isLoading: false,
        allItems: allProducts,
        filteredItems: filtered,
        categories: categories,
        productSuggestions: suggestions,
        selectedCategory: selected,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> _searchItems(
      SearchGroceryEvent event,
      Emitter<GroceryState> emit,
      ) async {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(state.copyWith(
        isSearching: false,
        searchResults: [],
      ));
      return;
    }

    emit(state.copyWith(isSearching: true));

    final results = state.allItems.where((item) {
      return item.name.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(
      isSearching: false,
      searchResults: results,
    ));
  }

  void _filterCategory(
      SelectCategoryEvent event,
      Emitter<GroceryState> emit,
      ) {
    if (event.category.isEmpty) {
      emit(state.copyWith(
        filteredItems: state.allItems,
        selectedCategory: "",
      ));
      return;
    }

    final filtered = state.allItems.where((item) {
      return item.category.trim().toLowerCase() ==
          event.category.trim().toLowerCase();
    }).toList();

    emit(state.copyWith(
      filteredItems: filtered,
      selectedCategory: event.category,
    ));
  }

  void _applyFilters(
      ApplyFilterEvent event,
      Emitter<GroceryState> emit,
      ) {
    List<GroceryModel> filtered =
    List.from(state.allItems);

    if (event.category != null &&
        event.category!.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.category.toLowerCase() ==
            event.category!.toLowerCase();
      }).toList();
    }

    if (event.item != null &&
        event.item!.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(
          event.item!.toLowerCase(),
        );
      }).toList();
    }

    emit(state.copyWith(
      filteredItems: filtered,
      selectedCategory:
      event.category ?? state.selectedCategory,
    ));
  }

  void _applyItemFilter(
      ApplyItemFilterEvent event,
      Emitter<GroceryState> emit,
      ) {
    final filtered = state.allItems.where((item) {
      return item.name.toLowerCase() ==
          event.selectedItem.toLowerCase();
    }).toList();

    emit(state.copyWith(
      filteredItems: filtered,
    ));
  }
}