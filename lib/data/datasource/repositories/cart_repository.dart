import 'package:dio/dio.dart';
import 'package:grocery_app/data/models/order_detail_response_model.dart';
import '../../../core/error/error_handler.dart';
import '../../../core/network/api_service.dart';
import '../../models/cart_response_model.dart';
import '../../models/grocery-item.dart';
import '../../models/my_orders_response_model.dart';
import '../../models/place_order_response_model.dart'; // Naya import

class CartRepository {
  final ApiService _apiService;
  CartRepository(this._apiService);

  Future<CartResponseModel> getCartItems() async {
    return await _apiService.getCartItem();
  }

  Future<CartResponseModel> addToCart(String productId, int quantity) async {
    try {
      final body = {
        "productId": productId,
        "quantity": quantity,
      };
      return await _apiService.addToCart(body);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<CartResponseModel> bulkAddToCart(
      List<GroceryItemModel> items,
      ) async {
    try {
      final body = {
        "products": items
            .map(
              (e) => {
            "productId": e.id,
            "quantity": e.quantity <= 0 ? 1 : e.quantity,
          },
        )
            .toList(),
      };

      return await _apiService.bulkAddToCart(body);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<CartResponseModel> removeToCart(
      String productId,
      ) async {
    try {
      return await _apiService.removeToCart(productId);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<CartResponseModel> updateCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      return await _apiService.updateCart({
        "productId": productId,
        "quantity": quantity,
      });
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<PlaceOrderResponseModel> placeOrder({
    required String addressId,
    required String paymentMethod,
  }) async {
    try {
      return await _apiService.placeOrder({
        "addressId": addressId,
        "paymentMethod": paymentMethod,
      });
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }


  Future<MyOrdersResponseModel> getMyOrders() async {
    try {
      final response = await _apiService.getMyOrders();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<MyOrdersResponseModel> cancelOrder(String id) async {
    try {
      return await _apiService.cancelOrder(id);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<OrderDetailResponseModel> getOrderDetails(String id) async {
    try {
      return await _apiService.getOrderDetails(id);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<MyOrdersResponseModel> reorderOrder(String id) async {
    try {
      return await _apiService.reorderOrder(id);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}