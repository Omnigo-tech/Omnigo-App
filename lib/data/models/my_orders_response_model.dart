// data/models/my_orders_response_model.dart

import 'package:grocery_app/data/models/order_model.dart';

class MyOrdersResponseModel {
  final bool success;
  final int count;
  final List<OrderModel> orders;

  MyOrdersResponseModel({
    required this.success,
    required this.count,
    required this.orders,
  });

  factory MyOrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return MyOrdersResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      orders: (json['orders'] as List?)
          ?.map((o) => OrderModel.fromJson(o))
          .toList() ?? [],
    );
  }
}