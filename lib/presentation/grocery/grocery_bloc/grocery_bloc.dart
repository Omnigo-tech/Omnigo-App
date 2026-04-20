import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'grocery_event.dart';
import 'grocery_state.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryBloc extends Bloc<GroceryEvent, GroceryState> {
  GroceryBloc() : super(GroceryState.initial()) {
    on<LoadGroceryEvent>(_loadData);
    on<SelectCategoryEvent>(_filterCategory);
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

  void _filterCategory(SelectCategoryEvent event, Emitter<GroceryState> emit) {
    final filtered = state.allItems
        .where((item) => item.category == event.category)
        .toList();

    emit(
      state.copyWith(filteredItems: filtered, selectedCategory: event.category),
    );
  }
}
