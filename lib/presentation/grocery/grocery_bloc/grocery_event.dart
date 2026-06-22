abstract class GroceryEvent {}

// Load all products from API
//class LoadGroceryEvent extends GroceryEvent {}

class LoadGroceryEvent extends GroceryEvent {
  final String? initialCategory;
  LoadGroceryEvent({this.initialCategory});
}

// Select a category tab
class SelectCategoryEvent extends GroceryEvent {
  final String category;
  SelectCategoryEvent(this.category);
}

// Search products via API
class SearchGroceryEvent extends GroceryEvent {
  final String query;
  SearchGroceryEvent(this.query);
}

// Apply filter from bottom sheet
class ApplyFilterEvent extends GroceryEvent {
  final String? category;
  final String? item;
  ApplyFilterEvent({this.category, this.item});
}

class ApplyItemFilterEvent extends GroceryEvent {
  final String selectedItem;
  ApplyItemFilterEvent(this.selectedItem);
}
