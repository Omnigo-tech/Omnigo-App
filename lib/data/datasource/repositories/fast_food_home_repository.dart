import '../../../core/network/api_service.dart';
import '../../models/fast_foods_models/brand_model.dart';
import '../../models/fast_foods_models/category_response_model.dart';
import '../../models/fast_foods_models/daily_deal_model.dart';
import '../../models/fast_foods_models/deal_details_model.dart';
import '../../models/fast_foods_models/fast_delivery_restaurant_model.dart';
import '../../models/fast_foods_models/fast_food_category_model.dart';
import '../../models/fast_foods_models/home_chef_model.dart';
import '../../models/fast_foods_models/popular_product_model.dart';
import '../../models/fast_foods_models/product_by_category_response_model.dart';
import '../../models/fast_foods_models/promotion_deal_model.dart';
import '../../models/fast_foods_models/sub_category_response_model.dart';

class FastFoodHomeRepository {
  final ApiService apiService;

  FastFoodHomeRepository(this.apiService);

  // GET /api/categories
  Future<List<CategoryModel>> getCategories() async {
    final CategoryResponseModel response =
    await apiService.getCategories();

    if (!response.success) {
      throw Exception('Failed to load categories');
    }

    return response.data;
  }

  // GET /api/categories/{categoryId}/subcategories
  Future<List<SubCategoryModel>> getSubCategories(
      String categoryId,
      ) async {
    final SubCategoryResponseModel response =
    await apiService.getSubCategories(categoryId);

    if (!response.success) {
      throw Exception('Failed to load subcategories');
    }

    return response.data;
  }

  Future<ProductByCategoryResponseModel>
  getProductsByCategory({
    required String category,
    required String subcategory,
  }) async {
    final response =
    await apiService.getProductsByCategory(
      category,
      subcategory,
    );

    if (!response.success) {
      throw Exception(
        'Failed to load products',
      );
    }

    return response;
  }
  Future<List<PromotionDealModel>> getPromotionDeals() async {
    final response = await apiService.getPromotionDeals();

    if (!response.success) {
      throw Exception('Failed to load promotion deals');
    }

    return response.data;
  }

  Future<List<BrandModel>> getRestaurantBrands() async {
    final response = await apiService.getRestaurantBrands();
    if (!response.success) {
      throw Exception('Failed to load brands');
    }
    return response.restaurants;
  }

  // GET /api/homeChefs
  Future<List<HomeChefModel>> getHomeChefs() async {
    final response = await apiService.getHomeChefs();
    if (!response.success) {
      throw Exception('Failed to load home chefs');
    }
    return response.chefs;
  }

  Future<List<FastDeliveryRestaurantModel>> getFastDeliveryRestaurants() async {
    try {
      final response = await apiService.getFastDeliveryRestaurants();
      if (!response.success) {
        throw Exception('Failed to load fast delivery restaurants');
      }
      return response.fastDeliveryRestaurants;
    } catch (e) {
      throw Exception('Failed to load fast delivery restaurants: $e');
    }
  }

  Future<List<DailyDealModel>> getDailyDeals({String type = "daily-deal"}) async {
    try {
      final response = await apiService.getDailyDeals(type);
      if (!response.success) {
        throw Exception('Failed to load daily deals');
      }
      return response.data;
    } catch (e) {
      throw Exception('Failed to load daily deals: $e');
    }
  }

  Future<List<PopularProductModel>> getPopularProducts({String type = "popular"}) async {
    try {
      final response = await apiService.getPopularProducts(type);
      if (!response.success) {
        throw Exception('Failed to fetch popular products');
      }
      return response.data;
    } catch (e) {
      throw Exception('Error fetching popular products: $e');
    }
  }


  Future<DealDetailModel> getDealDetails(
      String dealId,
      ) async {
    final response = await apiService.getDealDetails(dealId);

    if (!response.success) {
      throw Exception('Failed to load deal details');
    }

    return response.data;
  }
}

