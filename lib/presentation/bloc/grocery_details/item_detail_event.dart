import 'package:grocery_app/data/models/address.dart';

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

class RemoveFromCartEvent extends GroceryDetailEvent {
  final String id;
  RemoveFromCartEvent(this.id);
}

class PlaceOrderEvent extends GroceryDetailEvent {
  final AddressModel address;
  final String paymentMethod;

  PlaceOrderEvent(this.address, this.paymentMethod);
}

class CancelOrderEvent extends GroceryDetailEvent {
  final String orderId;

  CancelOrderEvent(this.orderId);
}

class ReorderItemsEvent extends GroceryDetailEvent {
  final List<GroceryItemModel> items;
  ReorderItemsEvent(this.items);
}

class LoadFavoritesEvent extends GroceryDetailEvent {}
