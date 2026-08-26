import 'package:grocery_app/data/models/order_detail_response_model.dart';

import '../../../data/models/grocery-item.dart';
import '../../../data/models/order_model.dart';

class GroceryDetailState {
  final List<GroceryItemModel> items;
  final List<GroceryItemModel> cart;
  final List<GroceryItemModel> favorites;
  final List<OrderModel> orders;
  final String orderId;
  final String message;
  final bool cartLoading;
  final bool isFavoritesLoading;
  final bool isOrderLoading;
  final bool isOrderDetailLoading;
  final OrderDetailModel? orderDetail;

  GroceryDetailState({
    required this.items,
    required this.cart,
    this.favorites = const [],
    this.orders = const [],
    this.orderId = '',
    this.message = '',
    this.cartLoading=false,
    this.isFavoritesLoading = true,
    this.isOrderLoading=false,
    this.isOrderDetailLoading=false,
    this.orderDetail,
  });

  GroceryDetailState copyWith({
    List<GroceryItemModel>? items,
    List<GroceryItemModel>? cart,
    List<GroceryItemModel>? favorites,
    List<OrderModel>? orders,
    String? orderId ,
    String? message,
    bool? cartLoading,
    bool? isFavoritesLoading,
    bool? isOrderLoading,
    OrderDetailModel? orderDetail,
    bool? isOrderDetailLoading,
  }) {
    return GroceryDetailState(
      items: items ?? this.items,
      cart: cart ?? this.cart,
      favorites: favorites ?? this.favorites,
      orders: orders ?? this.orders,
      orderId: orderId ?? this.orderId,
      message: message ?? this.message,
      cartLoading: cartLoading ?? this.cartLoading,
      isFavoritesLoading: isFavoritesLoading ?? this.isFavoritesLoading,
      isOrderLoading: isOrderLoading ?? this.isOrderLoading,
      orderDetail: orderDetail ?? this.orderDetail,
      isOrderDetailLoading: isOrderDetailLoading ?? this.isOrderDetailLoading,
    );
  }
}