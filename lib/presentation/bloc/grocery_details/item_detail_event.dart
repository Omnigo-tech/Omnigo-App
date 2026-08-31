import 'package:grocery_app/data/models/address.dart';

import '../../../data/models/grocery-item.dart';

abstract class GroceryDetailEvent {}

class LoadItemsEvent extends GroceryDetailEvent {}

class ToggleFavoriteEvent extends GroceryDetailEvent {
  final String id;
  ToggleFavoriteEvent(this.id);
}

class GetCartItemsEvent extends GroceryDetailEvent {}

class RemoveFavoriteEvent  extends GroceryDetailEvent {
  final String productId;

  RemoveFavoriteEvent(this.productId);
}

class AddToCartEvent extends GroceryDetailEvent {
  final List<GroceryItemModel> items;

  // Single item
  AddToCartEvent(GroceryItemModel item) : items = [item];

  // Multiple items
  AddToCartEvent.multiple(List<GroceryItemModel> items)
      : items = items;
}

// class BulkAddToCartEvent extends GroceryDetailEvent {
//   final List<GroceryItemModel> items;
//
//   BulkAddToCartEvent(this.items);
// }

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
  final String id;
  final String paymentMethod;

  PlaceOrderEvent(this.id, this.paymentMethod);
}

class CancelOrderEvent extends GroceryDetailEvent {
  final String orderId;

  CancelOrderEvent(this.orderId);
}


class LoadFavoritesEvent extends GroceryDetailEvent {}

class GetMyOrdersEvent extends GroceryDetailEvent {}

class GetOrderDetailsEvent extends GroceryDetailEvent {
  final String orderId;
  GetOrderDetailsEvent(this.orderId);
}

class CallReorderApiEvent extends GroceryDetailEvent {
  final String orderId;
  CallReorderApiEvent(this.orderId);

  @override
  List<Object> get props => [orderId];
}
