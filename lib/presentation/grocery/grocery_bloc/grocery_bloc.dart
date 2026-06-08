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
      final products = await repository.getProducts();

      emit(
        state.copyWith(
          isLoading: false,
          allItems: products,
          // ✅ Fix #1: Filter initial category with case-insensitive match
          filteredItems: products
              .where(
                (item) =>
                    item.category.toLowerCase() ==
                    state.selectedCategory.toLowerCase(),
              )
              .toList(),
          error: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // ✅ Fix #9: Search via API instead of local filtering
  Future<void> _searchItems(
    SearchGroceryEvent event,
    Emitter<GroceryState> emit,
  ) async {
    if (event.query.isEmpty) {
      // If query is cleared, restore current category filter
      final filtered = state.allItems
          .where(
            (item) =>
                item.category.toLowerCase() ==
                state.selectedCategory.toLowerCase(),
          )
          .toList();
      emit(state.copyWith(filteredItems: filtered));
      return;
    }

    try {
      final results = await repository.getProducts(search: event.query);
      emit(state.copyWith(filteredItems: results));
    } catch (e) {
      // Fallback to local search if API fails
      final query = event.query.toLowerCase();
      final results = state.allItems.where((item) {
        return item.name.toLowerCase().contains(query);
      }).toList();
      emit(state.copyWith(filteredItems: results));
    }
  }

  // ✅ Fix #1: Case-insensitive category filter
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

  // ✅ Fix #1: Case-insensitive in applyFilters too
  void _applyFilters(ApplyFilterEvent event, Emitter<GroceryState> emit) {
    List<GroceryModel> filtered = List.from(state.allItems);

    if (event.category != null && event.category!.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.category.toLowerCase() == event.category!.toLowerCase();
      }).toList();
    }

    if (event.item != null && event.item!.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name.toLowerCase() == event.item!.toLowerCase();
      }).toList();
    }

    emit(
      state.copyWith(
        filteredItems: filtered,
        selectedCategory: event.category ?? "",
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

/*import 'package:flutter_bloc/flutter_bloc.dart';
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

  //void _loadData(LoadGroceryEvent event, Emitter<GroceryState> emit) {
  //final groceryList = GroceryData.getGroceryList();
  Future<void> _loadData(
    LoadGroceryEvent event,
    Emitter<GroceryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final products = await repository.getProducts();

      emit(
        state.copyWith(
          isLoading: false,
          allItems: products,
          filteredItems: products,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /*emit(
      GroceryState(
        allItems: groceryList,
        filteredItems: groceryList
            .where((item) => item.category == state.selectedCategory)
            .toList(),
        selectedCategory: state.selectedCategory,
      ),
    );*/
  //}

  void _searchItems(SearchGroceryEvent event, Emitter<GroceryState> emit) {
    final query = event.query.toLowerCase();

    final results = state.allItems.where((item) {
      return item.name.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(filteredItems: results));
  }

  void _filterCategory(SelectCategoryEvent event, Emitter<GroceryState> emit) {
    if (event.category.isEmpty) {
      emit(state.copyWith(filteredItems: state.allItems, selectedCategory: ""));
      return;
    }

    final filtered = state.allItems.where((item) {
      // Case-insensitive comparison
      return item.category.toLowerCase() == event.category.toLowerCase();
    }).toList();

    emit(
      state.copyWith(filteredItems: filtered, selectedCategory: event.category),
    );
  }

  /*void _filterCategory(SelectCategoryEvent event, Emitter<GroceryState> emit) {
    if (event.category.isEmpty) {
      emit(state.copyWith(filteredItems: state.allItems, selectedCategory: ""));
      return;
    }

    final filtered = state.allItems
        .where((item) => item.category == event.category)
        .toList();

    emit(
      state.copyWith(filteredItems: filtered, selectedCategory: event.category),
    );
  }*/

  void _applyFilters(ApplyFilterEvent event, Emitter<GroceryState> emit) {
    List<GroceryModel> filtered = List.from(state.allItems);

    if (event.category != null && event.category!.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.category.toLowerCase() == event.category!.toLowerCase();
      }).toList();
      /*filtered = filtered.where((item) {
        return item.category == event.category;
      }).toList();*/
    }

    if (event.item != null && event.item!.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.name == event.item;
      }).toList();
    }

    emit(
      state.copyWith(
        filteredItems: filtered,
        selectedCategory: event.category ?? "",
      ),
    );
  }

  void _applyItemFilter(
    ApplyItemFilterEvent event,
    Emitter<GroceryState> emit,
  ) {
    final filtered = state.allItems.where((item) {
      return item.name == event.selectedItem;
    }).toList();

    emit(state.copyWith(filteredItems: filtered));
  }
}*/
