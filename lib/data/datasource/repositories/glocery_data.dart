import 'package:dio/dio.dart';
import 'package:grocery_app/core/error/error_handler.dart';
import 'package:grocery_app/core/network/api_service.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

import '../../models/grocery_category_model.dart';

class GroceryRepository {
  final ApiService apiService;

  GroceryRepository(this.apiService);

  Future<List<GroceryModel>> getProducts({
    String? category,
  }) async {
    try {
      final response = await apiService.getProducts(category);
      return response.data;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<GrocerySubCategoryModel>> getGroceryCategories() async {
    try {
      final response =
      await apiService.getGroceryCategories("grocery");

      if (response.data.isEmpty) {
        return [];
      }

      final categories = List<GrocerySubCategoryModel>.from(
        response.data.first.subCategories,
      );

      categories.sort(
            (a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0),
      );

      return categories;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
