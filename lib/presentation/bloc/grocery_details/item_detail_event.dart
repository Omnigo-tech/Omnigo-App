import '../../../data/models/grocery-item.dart';

abstract class GroceryDetailEvent {}

class LoadItemsEvent extends GroceryDetailEvent {}

class ToggleFavoriteEvent extends GroceryDetailEvent {
  final String id;
  ToggleFavoriteEvent(this.id);
}

class AddToCartEvent extends GroceryDetailEvent {
  final GroceryItemModel item;
  AddToCartEvent(this.item);
}

class IncrementQtyEvent extends GroceryDetailEvent {
  final String id;
  IncrementQtyEvent(this.id);
}

class DecrementQtyEvent extends GroceryDetailEvent {
  final String id;
  DecrementQtyEvent(this.id);
}