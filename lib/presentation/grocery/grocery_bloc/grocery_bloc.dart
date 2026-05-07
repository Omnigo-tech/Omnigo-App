import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import '../../../data/datasource/repositories/glocery_data.dart';
import 'grocery_event.dart';
import 'grocery_state.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  GroceryBloc() : super(GroceryState.initial()) {
    on<LoadGroceryEvent>(_loadData);
    on<SearchGroceryEvent>(_searchItems);
    on<SelectCategoryEvent>(_filterCategory);
    on<ApplyFilterEvent>(_applyFilters);
    on<ApplyItemFilterEvent>(_applyItemFilter);
  }

  void _loadData(LoadGroceryEvent event, Emitter<GroceryState> emit) {
    final groceryList = GroceryData.getGroceryList();

    emit(
      GroceryState(
        allItems: groceryList,
        filteredItems: groceryList
            .where((item) => item.category == state.selectedCategory)
            .toList(),
        selectedCategory: state.selectedCategory,
      ),
    );
  }

  void _searchItems(SearchGroceryEvent event, Emitter<GroceryState> emit) {
    final query = event.query.toLowerCase();

    final results = state.allItems.where((item) {
      return item.name.toLowerCase().contains(query);
    }).toList();

    emit(state.copyWith(filteredItems: results));
  }

  void _filterCategory(SelectCategoryEvent event, Emitter<GroceryState> emit) {
    if (event.category.isEmpty) {
      emit(state.copyWith(
        filteredItems: state.allItems,
        selectedCategory: "",
      ));
      return;
    }

    final filtered = state.allItems
        .where((item) => item.category == event.category)
        .toList();

    emit(
      state.copyWith(
        filteredItems: filtered,
        selectedCategory: event.category,
      ),
    );
  }

  void _applyFilters(ApplyFilterEvent event, Emitter<GroceryState> emit) {
    List<GroceryModel> filtered = List.from(state.allItems);

    if (event.category != null && event.category!.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.category == event.category;
      }).toList();
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
}
