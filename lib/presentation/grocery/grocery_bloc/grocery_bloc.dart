import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import '../../../data/datasource/repositories/glocery_data.dart';
import 'grocery_event.dart';
import 'grocery_state.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  GroceryBloc() : super(GroceryState.initial()) {
    on<LoadGroceryEvent>(_loadData);
    on<SelectCategoryEvent>(_filterCategory);
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

  void _filterCategory(SelectCategoryEvent event, Emitter<GroceryState> emit) {
    final filtered = state.allItems
        .where((item) => item.category == event.category)
        .toList();

    emit(
      state.copyWith(filteredItems: filtered, selectedCategory: event.category),
    );
  }
}
