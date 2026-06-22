import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/repositories/glocery_data.dart';
import 'grocery_event.dart';
import 'grocery_state.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  final GroceryRepository repository;
  final Random _random = Random();

  GroceryBloc(this.repository) : super(GroceryState.initial()) {
    on<LoadGroceryEvent>(_loadData);
    on<SearchGroceryEvent>(_searchItems);
    on<SelectCategoryEvent>(_filterCategory);
    on<ApplyFilterEvent>(_applyFilters);
    on<ApplyItemFilterEvent>(_applyItemFilter);
  }
  // Normalizes category strings so "Vegetable"/"vegetables"/"Vegetables"
  // all collapse into one consistent display value ("Vegetables").
  String _normalizeCategory(String raw) {
    var cat = raw.trim();
    if (cat.isEmpty) return cat;

    cat = cat.toLowerCase();

    String singular = cat.endsWith('s') && cat.length > 3
        ? cat.substring(0, cat.length - 1)
        : cat;

    String display = singular.endsWith('s') ? singular : '${singular}s';
    display = display[0].toUpperCase() + display.substring(1);

    return display;
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
        final normalized = _normalizeCategory(product.category);
        if (normalized.isEmpty) continue;
        grouped.putIfAbsent(normalized, () => []).add(product);
      }

      final categories = grouped.keys.toList()..sort();

      // Pick a random product image per category.
      // GroceryModel.image is String? (nullable) — guard with ?. and ?? ""
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
          final normalized =
              name[0].toUpperCase() + name.substring(1).toLowerCase();
          nameSet.add(normalized);
        }
      }
      final suggestions = nameSet.toList()..sort();

      // KEY FIX: honor initialCategory passed from caller (e.g. Home
      // screen tapping a category) instead of always defaulting to the
      // first category. Falls back to first category if the requested
      // one doesn't exist among loaded categories.
      String selected;
      if (event.initialCategory != null && event.initialCategory!.isNotEmpty) {
        final normalizedRequested = _normalizeCategory(event.initialCategory!);
        selected = categories.contains(normalizedRequested)
            ? normalizedRequested
            : (categories.isNotEmpty ? categories.first : "");
      } else {
        selected = categories.isNotEmpty ? categories.first : "";
      }

      final filtered = products.where((item) {
        return _normalizeCategory(item.category) == selected;
      }).toList();

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

  /*Future<void> _loadData(
    LoadGroceryEvent event,
    Emitter<GroceryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final products = await repository.getProducts();

      //  Group products by normalized category name
      final Map<String, List<GroceryModel>> grouped = {};
      for (final product in products) {
        final cat = product.category.trim();
        if (cat.isEmpty) continue;
        final normalized =
            cat[0].toUpperCase() + cat.substring(1).toLowerCase();
        grouped.putIfAbsent(normalized, () => []).add(product);
      }

      final categories = grouped.keys.toList()..sort();

      // Pick a random product image for each category (only from
      // products that actually have a non-empty image)
      final Map<String, String> categoryImages = {};
      for (final cat in categories) {
        final itemsWithImage = grouped[cat]!
            .where((p) => p.image!.isNotEmpty)
            .toList();
        if (itemsWithImage.isNotEmpty) {
          final randomItem =
              itemsWithImage[_random.nextInt(itemsWithImage.length)];
          categoryImages[cat] = randomItem.image!;
        } else {
          categoryImages[cat] =
              ""; // no image available, UI will show placeholder
        }
      }

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

      final firstCategory = categories.isNotEmpty ? categories.first : "";
      /*String selectedCategory = event.initialCategory ?? "";
      if (selectedCategory.isEmpty && categories.isNotEmpty) {
        selectedCategory = categories.first;
      }*/
      final filtered = products.where((item) {
        return item.category.toLowerCase() == firstCategory.toLowerCase();
        //return item.category.toLowerCase() == selectedCategory.toLowerCase();
      }).toList();

      emit(
        state.copyWith(
          isLoading: false,
          allItems: products,
          filteredItems: filtered,
          categories: categories,
          categoryImages: categoryImages,
          productSuggestions: suggestions,
          selectedCategory: firstCategory,
          //selectedCategory: selectedCategory,
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }*/

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

  /*void _filterCategory(SelectCategoryEvent event, Emitter<GroceryState> emit) {
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
  }*/
  // Uses normalized comparison so it always matches the grouped
  // categories shown in the UI (fixes "Fruit" vs "Fruits" mismatches)
  void _filterCategory(SelectCategoryEvent event, Emitter<GroceryState> emit) {
    if (event.category.isEmpty) {
      emit(state.copyWith(filteredItems: state.allItems, selectedCategory: ""));
      return;
    }

    final normalizedTarget = _normalizeCategory(event.category);

    final filtered = state.allItems.where((item) {
      return _normalizeCategory(item.category) == normalizedTarget;
    }).toList();

    emit(
      state.copyWith(
        filteredItems: filtered,
        selectedCategory: normalizedTarget,
      ),
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
