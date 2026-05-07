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
  final String? category;
  final String? item;

  ApplyFilterEvent({this.category, this.item});
}

class ApplyItemFilterEvent extends GroceryEvent {
  final String selectedItem;

  ApplyItemFilterEvent( this.selectedItem);
}
