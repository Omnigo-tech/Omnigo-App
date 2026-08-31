abstract class GroceryEvent {}

// Load all products from API
class LoadGroceryEvent extends GroceryEvent {
  final String? initialCategory;
  final bool showAll;
  final bool forceRefresh; // true = hamesha dobara fetch karo (jaise pull-to-refresh)
  LoadGroceryEvent({
    this.initialCategory,
    this.showAll = false,
    this.forceRefresh = false,
  });
}

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
  ApplyItemFilterEvent(this.selectedItem);
}

class UpdateFavoriteStatusEvent extends GroceryEvent {
  final String productId;
  final bool isFavourite;

  UpdateFavoriteStatusEvent({
    required this.productId,
    required this.isFavourite,
  });
}