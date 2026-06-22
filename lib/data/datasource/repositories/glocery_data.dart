import 'package:dio/dio.dart';
import 'package:grocery_app/core/error/error_handler.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/network/api_service.dart';
import 'package:grocery_app/presentation/grocery/grocery_data/grocery_model.dart';

class GroceryRepository {
  final ApiService apiService;

  GroceryRepository(this.apiService);

  Future<List<GroceryModel>> getProducts({
    String? category,
    String? search,
  }) async {
    try {
      return await apiService.getProducts(category, search);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}

