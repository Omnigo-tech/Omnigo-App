import 'package:dio/dio.dart';
import 'package:grocery_app/core/network/api_service.dart';

import '../../../core/error/error_handler.dart';
import '../../models/grocery-item.dart';
import '../../models/remove_favourite_response_model.dart';
import '../../models/wishlist_toggle_response_model.dart';

class WishlistRepository {
  final ApiService _apiService;
  WishlistRepository(this._apiService);

  Future<WishlistToggleResponseModel> toggleWishlist(String productId) async {
    try {
      final body = {
        "productId": productId,
      };

      return await _apiService.toggleWishlist(body);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }

  }

  Future<List<GroceryItemModel>> getFavorites() async {
    final response = await _apiService.getFavorites();
    return response.favorites;
  }

  Future<RemoveFavouriteResponseModel> removeFavorite(
      String productId,
      ) async {
    try {
      return await _apiService.removeFavorite(productId);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }


}