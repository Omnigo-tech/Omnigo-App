import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
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
    List<GroceryModel> groceryList = [
      GroceryModel(
        id: "1",
        name: "Ginger",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 101,
      ),
      GroceryModel(
        id: "2",
        name: "Green Chilli",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 40,
      ),
      GroceryModel(
        id: "3",
        name: "Apple",
        category: "Fruits",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 120,
      ),
      GroceryModel(
        id: "4",
        name: "Chicken",
        category: "Meat",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 500,
      ),
      GroceryModel(
        id: "1",
        name: "Ginger",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 101,
      ),
      GroceryModel(
        id: "2",
        name: "Green Chilli",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 40,
      ),
      GroceryModel(
        id: "3",
        name: "Apple",
        category: "Fruits",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 120,
      ),
      GroceryModel(
        id: "4",
        name: "Chicken",
        category: "Meat",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 500,
      ),
      GroceryModel(
        id: "1",
        name: "Ginger",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 101,
      ),
      GroceryModel(
        id: "2",
        name: "Green Chilli",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 40,
      ),
      GroceryModel(
        id: "3",
        name: "Apple",
        category: "Fruits",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 120,
      ),
      GroceryModel(
        id: "4",
        name: "Chicken",
        category: "Meat",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 500,
      ),
      GroceryModel(
        id: "1",
        name: "Ginger",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 101,
      ),
      GroceryModel(
        id: "2",
        name: "Green Chilli",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 40,
      ),
      GroceryModel(
        id: "3",
        name: "Apple",
        category: "Fruits",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 120,
      ),
      GroceryModel(
        id: "4",
        name: "Chicken",
        category: "Meat",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 500,
      ),
      GroceryModel(
        id: "1",
        name: "Ginger",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 101,
      ),
      GroceryModel(
        id: "2",
        name: "Green Chilli",
        category: "Vegetables",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 40,
      ),
      GroceryModel(
        id: "3",
        name: "Apple",
        category: "Fruits",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 120,
      ),
      GroceryModel(
        id: "4",
        name: "Chicken",
        category: "Meat",
        image: ImageResource.VEGETABLE_IMAGE,
        price: 500,
      ),
    ];
    emit(
      GroceryState(
        allItems: groceryList,
        filteredItems: groceryList
            .where((item) => item.category == "Vegetables")
            .toList(),
        selectedCategory: "Vegetables",
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
    final filtered = state.allItems
        .where((item) => item.category == event.category)
        .toList();

    emit(
      state.copyWith(filteredItems: filtered, selectedCategory: event.category),
    );
  }

  void _applyFilters(ApplyFilterEvent event, Emitter<GroceryState> emit) {
    if (event.selectedCategories.isEmpty) {
      emit(state.copyWith(filteredItems: state.allItems));
      return;
    }

    final filtered = state.allItems.where((item) {
      return event.selectedCategories.contains(item.category);
    }).toList();

    emit(state.copyWith(filteredItems: filtered));
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
