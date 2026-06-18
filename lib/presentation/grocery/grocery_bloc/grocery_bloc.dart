import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/repositories/glocery_data.dart';
import 'grocery_event.dart';
import 'grocery_state.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  final GroceryRepository repository;

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
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // Fetch all products from API
      final products = await repository.getProducts();

      // Extract unique categories from API response (capitalize first letter)
      final Set<String> categorySet = {};
      for (final product in products) {
        final cat = product.category.trim();
        if (cat.isNotEmpty) {
          // Capitalize first letter for display consistency
          final normalized =
              cat[0].toUpperCase() + cat.substring(1).toLowerCase();
          categorySet.add(normalized);
        }
      }
      final categories = categorySet.toList()..sort();

      // Extract unique product names for search suggestions
      final Set<String> nameSet = {};
      for (final product in products) {
        final name = product.name.trim();
        if (name.isNotEmpty) {
          final normalized =
              name[0].toUpperCase() + name.substring(1).toLowerCase();
          nameSet.add(normalized);
        }
      }
      final suggestions = nameSet.toList()..sort();

      // Default: select first category
      final firstCategory = categories.isNotEmpty ? categories.first : "";

      // Filter products for first category
      final filtered = products.where((item) {
        return item.category.toLowerCase() == firstCategory.toLowerCase();
      }).toList();

      emit(
        state.copyWith(
          isLoading: false,
          allItems: products,
          filteredItems: filtered,
          categories: categories,
          productSuggestions: suggestions,
          selectedCategory: firstCategory,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // Search via API, results shown in search screen
  Future<void> _searchItems(
    SearchGroceryEvent event,
    Emitter<GroceryState> emit,
  ) async {
    if (event.query.isEmpty) {
      // Clear search results when query is empty
      emit(state.copyWith(isSearching: false, searchResults: []));
      return;
    }

    emit(state.copyWith(isSearching: true));

    try {
      final results = await repository.getProducts(search: event.query);
      emit(state.copyWith(isSearching: false, searchResults: results));
    } catch (e) {
      // Fallback: local search from allItems
      final query = event.query.toLowerCase();
      final results = state.allItems.where((item) {
        return item.name.toLowerCase().contains(query);
      }).toList();
      emit(state.copyWith(isSearching: false, searchResults: results));
    }
  }

  // Case-insensitive category filter
  void _filterCategory(SelectCategoryEvent event, Emitter<GroceryState> emit) {
    if (event.category.isEmpty) {
      emit(state.copyWith(filteredItems: state.allItems, selectedCategory: ""));
      return;
    }

    final filtered = state.allItems.where((item) {
      return item.category.toLowerCase() == event.category.toLowerCase();
    }).toList();

    emit(
      state.copyWith(filteredItems: filtered, selectedCategory: event.category),
    );
  }

  // Apply filters from FilterBottomSheet
  void _applyFilters(ApplyFilterEvent event, Emitter<GroceryState> emit) {
    List<GroceryModel> filtered = List.from(state.allItems);

    if (event.category != null && event.category!.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.category.toLowerCase() == event.category!.toLowerCase();
      }).toList();
    }

    if (event.item != null && event.item!.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.toLowerCase().contains(event.item!.toLowerCase());
      }).toList();
    }

    emit(
      state.copyWith(
        filteredItems: filtered,
        selectedCategory: event.category ?? state.selectedCategory,
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
}
