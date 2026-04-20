import '../../../data/models/grocery-item.dart';
class GroceryDetailState {
  final List<GroceryItemModel> items;
  final List<GroceryItemModel> cart;

  GroceryDetailState({
    required this.items,
    required this.cart,
  });

  GroceryDetailState copyWith({
    List<GroceryItemModel>? items,
    List<GroceryItemModel>? cart,
  }) {
    return GroceryDetailState(
      items: items ?? this.items,
      cart: cart ?? this.cart,
    );
  }
}
