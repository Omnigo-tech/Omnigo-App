import '../../../data/models/grocery-item.dart';

abstract class GroceryUiEffect {}

class ShowSnackbarEffect extends GroceryUiEffect {
  final String message;

  ShowSnackbarEffect(this.message);
}

class ShowAddedToCartDialogEffect extends GroceryUiEffect {
  final List<GroceryItemModel> items;

  ShowAddedToCartDialogEffect({
    required this.items,
  });
}

class OrderPlacedEffect extends GroceryUiEffect {
  final String orderId;

  OrderPlacedEffect(this.orderId);
}

/// Tells the rest of the app that wishlist state changed successfully.
class FavoriteUpdatedEffect extends GroceryUiEffect {
  final String productId;
  final bool isFavourite;

  FavoriteUpdatedEffect({
    required this.productId,
    required this.isFavourite,
  });
}