abstract class GroceryEvent {}

class LoadGroceryEvent extends GroceryEvent {}

class SelectCategoryEvent extends GroceryEvent {
  final String category;

  SelectCategoryEvent(this.category);
}

class SearchGroceryEvent extends GroceryEvent {
  final String query;

  SearchGroceryEvent(this.query);
}

class ApplyFilterEvent extends GroceryEvent {
  final List<String> selectedCategories;

  ApplyFilterEvent(this.selectedCategories);
}

class ApplyItemFilterEvent extends GroceryEvent {
  final String selectedItem;

  ApplyItemFilterEvent(this.selectedItem);
}
