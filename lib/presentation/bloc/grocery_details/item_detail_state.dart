import 'package:grocery_app/data/models/order_model.dart';
import '../../../data/models/grocery-item.dart';

class GroceryDetailState {
  final List<GroceryItemModel> items;
  final List<GroceryItemModel> cart;
  final List<OrderModel> orders;

  GroceryDetailState({
    required this.items,
    required this.cart,
    this.orders = const [],
  });

  List<GroceryItemModel> get favoriteItems =>
      items.where((item) => item.isFavorite).toList();

  GroceryDetailState copyWith({
    List<GroceryItemModel>? items,
    List<GroceryItemModel>? cart,
    List<OrderModel>? orders,
  }) {
    return GroceryDetailState(
      items: items ?? this.items,
      cart: cart ?? this.cart,
      orders: orders ?? this.orders,
    );
  }
}
