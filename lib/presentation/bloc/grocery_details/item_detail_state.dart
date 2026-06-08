import '../../../data/models/grocery-item.dart';
import '../../../data/models/order_model.dart';

class GroceryDetailState {
  final List<GroceryItemModel> items;
  final List<GroceryItemModel> cart;
  final List<GroceryItemModel> favorites;

  final List<OrderModel> orders;

  GroceryDetailState({
    required this.items,
    required this.cart,
    this.favorites = const [],
    this.orders = const [],
  });

  GroceryDetailState copyWith({
    List<GroceryItemModel>? items,
    List<GroceryItemModel>? cart,
    List<GroceryItemModel>? favorites,
    List<OrderModel>? orders,
  }) {
    return GroceryDetailState(
      items: items ?? this.items,
      cart: cart ?? this.cart,
      favorites: favorites ?? this.favorites,
      orders: orders ?? this.orders,
    );
  }
}