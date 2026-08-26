import '../../models/fast_foods_models/restaurant_model.dart';
import '../../models/fast_foods_models/restaurant_response_models.dart';
import '../../../core/network/api_service.dart';

class RestaurantRepository {
  final ApiService apiService;

  RestaurantRepository(this.apiService);


  // =====================================================
  // API 1
  // RESTAURANT DETAILS
  // =====================================================

  Future<RestaurantModel> getRestaurantDetails(
      String restaurantId,
      ) async {
    final response =
    await apiService.getRestaurantDetails(
      restaurantId,
    );

    if (!response.success) {
      throw Exception(
        'Failed to load restaurant details',
      );
    }

    return response.restaurant;
  }


  // =====================================================
  // API 2
  // RESTAURANT CATEGORIES
  // =====================================================

  Future<List<RestaurantCategoryModel>>
  getRestaurantCategories(
      String restaurantId,
      ) async {
    final response =
    await apiService.getRestaurantCategories(
      restaurantId,
    );

    if (!response.success) {
      throw Exception(
        'Failed to load restaurant categories',
      );
    }

    return response.categories;
  }


  // =====================================================
  // API 3
  // RESTAURANT MENU
  // =====================================================

  Future<List<FoodCategorySection>>
  getRestaurantMenu(
      String restaurantId,
      ) async {
    final response =
    await apiService.getRestaurantMenu(
      restaurantId,
    );

    return _parseMenuResponse(response);
  }


  // =====================================================
  // API 4
  // PRODUCTS BY CATEGORY
  // =====================================================

  Future<List<RestaurantFoodItemModel>>
  getProductsByRestaurantCategory({
    required String restaurantId,
    required String categoryName,
  }) async {
    final response =
    await apiService.getProductsByRestaurantCategory(
      restaurantId,
      categoryName,
    );

    if (!response.success) {
      throw Exception(
        'Failed to load category products',
      );
    }

    return response.products;
  }


  // =====================================================
  // MENU RESPONSE PARSER
  // =====================================================

  List<FoodCategorySection> _parseMenuResponse(
      dynamic response,
      ) {
    dynamic rawData = response;

    if (rawData is Map) {
      final map = Map<String, dynamic>.from(rawData);

      if (map['menu'] is List) {
        rawData = map['menu'];
      } else if (map['sections'] is List) {
        rawData = map['sections'];
      } else if (map['categories'] is List) {
        rawData = map['categories'];
      } else if (map['data'] is List) {
        rawData = map['data'];
      } else {
        return [];
      }
    }

    if (rawData is! List) {
      return [];
    }

    final sections = <FoodCategorySection>[];

    for (final sectionItem in rawData) {
      if (sectionItem is! Map) continue;

      final section =
      Map<String, dynamic>.from(sectionItem);

      final categoryName =
          section['categoryName']?.toString() ??
              section['categoryTitle']?.toString() ??
              section['name']?.toString() ??
              section['title']?.toString() ??
              '';

      dynamic rawProducts =
          section['products'] ??
              section['items'] ??
              section['foods'];

      if (rawProducts is! List) {
        rawProducts = [];
      }

      final products = <RestaurantFoodItemModel>[];

      for (final productItem in rawProducts) {
        if (productItem is! Map) continue;

        final product =
        Map<String, dynamic>.from(productItem);

        final images = product['images'];

        String image = '';

        if (images is List && images.isNotEmpty) {
          image = images.first?.toString() ?? '';
        } else if (product['image'] != null) {
          image = product['image'].toString();
        }

        products.add(
          RestaurantFoodItemModel(
            id: product['_id']?.toString() ?? '',
            name: product['name']?.toString() ?? '',
            description:
            product['description']?.toString() ?? '',
            price: _formatPrice(product['price']),
            image: image,
            rating: _parseRating(product['rating']),
          ),
        );
      }

      if (categoryName.isNotEmpty) {
        sections.add(
          FoodCategorySection(
            categoryTitle: categoryName,
            items: products,
          ),
        );
      }
    }

    return sections;
  }


  String _formatPrice(dynamic price) {
    if (price == null) return '';

    if (price is num) {
      return 'Rs ${price.toStringAsFixed(0)}';
    }

    return 'Rs $price';
  }


  double? _parseRating(dynamic rating) {
    if (rating == null) return null;

    if (rating is num) {
      return rating.toDouble();
    }

    return double.tryParse(
      rating.toString(),
    );
  }
}