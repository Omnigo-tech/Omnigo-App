abstract class GroceryEvent {}

class LoadGroceryEvent extends GroceryEvent {}

class SelectCategoryEvent extends GroceryEvent {
  final String category;

  SelectCategoryEvent(this.category);
}
