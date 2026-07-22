import 'order_model.dart';

class PlaceOrderResponseModel {
  final bool success;
  final String message;
  final String orderId;


  PlaceOrderResponseModel({
    required this.success,
    required this.message,
      required this.orderId
  });

  factory PlaceOrderResponseModel.fromJson(
      Map<String, dynamic> json) {
    return PlaceOrderResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      orderId: json['orderId'] ?? '',
    );
  }
}