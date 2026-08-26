import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/repositories/glocery_data.dart';
import 'grocery_event.dart';
import 'grocery_state.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  final GroceryRepository repository;
  final Random _random = Random();

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
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final products = await repository.getProducts();

      final Map<String, List<GroceryModel>> grouped = {};
      for (final product in products) {
        final cat = product.category.trim();
        if (cat.isEmpty) continue;
        final display = cat[0].toUpperCase() + cat.substring(1).toLowerCase();
        grouped.putIfAbsent(display, () => []).add(product);
      }

      final categories = grouped.keys.toList()..sort();

      // Pick a random product image per category.
      // GroceryModel.image is String? (nullable) — guard with ?? ""
      final Map<String, String> categoryImages = {};
      for (final cat in categories) {
        final itemsWithImage = grouped[cat]!
            .where((p) => (p.image ?? "").isNotEmpty)
            .toList();
        if (itemsWithImage.isNotEmpty) {
          final randomItem =
              itemsWithImage[_random.nextInt(itemsWithImage.length)];
          categoryImages[cat] = randomItem.image ?? "";
        } else {
          categoryImages[cat] = "";
        }
      }

      // Extract unique product names for search suggestions
      final Set<String> nameSet = {};
      for (final product in products) {
        final name = product.name.trim();
        if (name.isNotEmpty) {
          final normalizedName =
              name[0].toUpperCase() + name.substring(1).toLowerCase();
          nameSet.add(normalizedName);
        }
      }
      final suggestions = nameSet.toList()..sort();
      String selected;
      List<GroceryModel> filtered;

      if (event.showAll) {
        // "See all" — show everything, no category selected
        selected = "";
        filtered = products;
      } else if (event.initialCategory != null &&
          event.initialCategory!.isNotEmpty) {
        // A specific category was requested (e.g. tapped from Home)
        final requested = event.initialCategory!.trim().toLowerCase();
        selected = categories.firstWhere(
          (c) => c.toLowerCase() == requested,
          orElse: () => categories.isNotEmpty ? categories.first : "",
        );
        filtered = products.where((item) {
          return item.category.trim().toLowerCase() == selected.toLowerCase();
        }).toList();
      } else if (_hasLoadedOnce && state.selectedCategory.isNotEmpty) {
        selected = categories.contains(state.selectedCategory)
            ? state.selectedCategory
            : (categories.isNotEmpty ? categories.first : "");
        filtered = products.where((item) {
          return item.category.trim().toLowerCase() == selected.toLowerCase();
        }).toList();
      } else {
        selected = categories.isNotEmpty ? categories.first : "";
        filtered = products.where((item) {
          return item.category.trim().toLowerCase() == selected.toLowerCase();
        }).toList();
      }

      _hasLoadedOnce = true;

      emit(
        state.copyWith(
          isLoading: false,
          allItems: products,
          filteredItems: filtered,
          categories: categories,
          categoryImages: categoryImages,
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
    if (event.query.isEmpty) {
      emit(state.copyWith(isSearching: false, searchResults: []));
      return;
    }

    emit(state.copyWith(isSearching: true));

    try {
      final results = await repository.getProducts(search: event.query);
      emit(state.copyWith(isSearching: false, searchResults: results));
    } catch (e) {
      final query = event.query.toLowerCase();
      final results = state.allItems.where((item) {
        return item.name.toLowerCase().contains(query);
      }).toList();
      emit(state.copyWith(isSearching: false, searchResults: results));
    }
  }

  // Plain case-insensitive match — no normalization
  // Uses normalized comparison so it always matches the grouped
  // categories shown in the UI (fixes "Fruit" vs "Fruits" mismatches)
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
