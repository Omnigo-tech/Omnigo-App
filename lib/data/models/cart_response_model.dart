

import 'grocery-item.dart';

class CartResponseModel {
  final bool success;
  final String message;
  final List<GroceryItemModel> cartItems;

  CartResponseModel({
    required this.success,
    required this.message,
    required this.cartItems,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['cart'] != null ? json['cart']['items'] as List : [];
    List<GroceryItemModel> itemsList = list.map((i) {
      return GroceryItemModel(
        id: i['productId'] ?? '',
        name: i['name'] ?? '',
        image: i['image'] ?? '',
        price: (i['price'] as num).toDouble(),
        quantity: i['quantity'] ?? 1,
        weight: i['weight'] ?? '',
        description: i['description'] ?? '',
        belongsTo: i['belongsTo'] ?? '',
      );
    }).toList();

    return CartResponseModel(
      success: json['success'] ?? false,
      message: json['msg'] ?? '',
      cartItems: itemsList,
    );
  }
}