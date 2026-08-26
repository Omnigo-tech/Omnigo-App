import 'restaurant_model.dart';

class RestaurantDetailsResponseModel {
  final bool success;
  final RestaurantModel restaurant;

  RestaurantDetailsResponseModel({
    required this.success,
    required this.restaurant,
  });

  factory RestaurantDetailsResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RestaurantDetailsResponseModel(
      success: json['success'] == true,
      restaurant: RestaurantModel.fromJson(
        Map<String, dynamic>.from(
          json['restaurant'] ?? {},
        ),
      ),
    );
  }
}


// =====================================================
// CATEGORY RESPONSE
// =====================================================

class RestaurantCategoriesResponseModel {
  final bool success;
  final int count;
  final List<RestaurantCategoryModel> categories;

  RestaurantCategoriesResponseModel({
    required this.success,
    required this.count,
    required this.categories,
  });

  factory RestaurantCategoriesResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawCategories = json['categories'];

    final List<RestaurantCategoryModel> categories = [];

    if (rawCategories is List) {
      for (final item in rawCategories) {
        if (item is Map) {
          categories.add(
            RestaurantCategoryModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          );
        }
      }
    }

    return RestaurantCategoriesResponseModel(
      success: json['success'] == true,
      count: json['count'] is num
          ? (json['count'] as num).toInt()
          : categories.length,
      categories: categories,
    );
  }
}


// =====================================================
// PRODUCTS BY RESTAURANT CATEGORY RESPONSE
// =====================================================

class RestaurantCategoryProductsResponseModel {
  final bool success;
  final int count;
  final List<RestaurantFoodItemModel> products;

  RestaurantCategoryProductsResponseModel({
    required this.success,
    required this.count,
    required this.products,
  });

  factory RestaurantCategoryProductsResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final rawProducts = json['products'];

    final List<RestaurantFoodItemModel> products = [];

    if (rawProducts is List) {
      for (final item in rawProducts) {
        if (item is Map) {
          final map = Map<String, dynamic>.from(item);

          final images = map['images'];

          String image = '';

          if (images is List && images.isNotEmpty) {
            image = images.first?.toString() ?? '';
          } else if (map['image'] != null) {
            image = map['image'].toString();
          }

          products.add(
            RestaurantFoodItemModel(
              id: map['_id']?.toString() ?? '',
              name: map['name']?.toString() ?? '',
              description:
              map['description']?.toString() ?? '',
              price: _formatPrice(map['price']),
              image: image,
              rating: _parseRating(map['rating']),
            ),
          );
        }
      }
    }

    return RestaurantCategoryProductsResponseModel(
      success: json['success'] == true,
      count: json['count'] is num
          ? (json['count'] as num).toInt()
          : products.length,
      products: products,
    );
  }

  static String _formatPrice(dynamic price) {
    if (price == null) return '';

    if (price is num) {
      return 'Rs ${price.toStringAsFixed(0)}';
    }

    return 'Rs $price';
  }

  static double? _parseRating(dynamic rating) {
    if (rating == null) return null;

    if (rating is num) {
      return rating.toDouble();
    }

    return double.tryParse(rating.toString());
  }
}