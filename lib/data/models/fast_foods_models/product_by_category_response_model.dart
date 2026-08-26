class ProductByCategoryResponseModel {
  final bool success;
  final int count;
  final List<ProductModel> products;
  final List<RestaurantModel> restaurants;

  ProductByCategoryResponseModel({
    required this.success,
    required this.count,
    required this.products,
    required this.restaurants,
  });

  factory ProductByCategoryResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final List<dynamic> data = json['data'] ?? [];

    final List<ProductModel> products = [];
    final List<RestaurantModel> restaurants = [];

    for (final item in data) {
      if (item is! Map<String, dynamic>) continue;

      // Product has "price"
      if (item.containsKey('price')) {
        products.add(
          ProductModel.fromJson(item),
        );
      }

      // Restaurant has "logo" and does not have price
      else if (item.containsKey('logo')) {
        restaurants.add(
          RestaurantModel.fromJson(item),
        );
      }
    }

    return ProductByCategoryResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? products.length,
      products: products,
      restaurants: restaurants,
    );
  }
}

class ProductModel {
  final String id;
  final String name;
  final List<String> images;

  final String belongsTo;
  final String restaurantId;

  final String category;
  final String subcategory;

  final double price;
  final double discountPrice;

  final double rating;
  final int ratingCount;

  final List<ProductTagModel> tags;

  final bool isAvailable;
  final bool isFavourite;

  ProductModel({
    required this.id,
    required this.name,
    required this.images,
    required this.belongsTo,
    required this.restaurantId,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.discountPrice,
    required this.rating,
    required this.ratingCount,
    required this.tags,
    required this.isAvailable,
    required this.isFavourite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final ratingObject = json['rating'];

    final List<dynamic> imageData =
        json['images'] ?? [];

    final List<dynamic> tagData =
        json['tags'] ?? [];

    return ProductModel(
      id: json['_id'] ?? '',

      name: json['name'] ?? '',

      images: imageData
          .map((e) => e.toString())
          .toList(),

      belongsTo:
      json['belongsTo'] ?? '',

      restaurantId:
      json['restaurantId'] ?? '',

      category:
      json['category'] ?? '',

      subcategory:
      json['subcategory'] ?? '',

      price:
      (json['price'] ?? 0).toDouble(),

      discountPrice:
      (json['discountPrice'] ?? 0).toDouble(),

      rating:
      (ratingObject?['average'] ?? 0).toDouble(),

      ratingCount:
      ratingObject?['count'] ?? 0,

      tags: tagData
          .whereType<Map<String, dynamic>>()
          .map(
            (e) => ProductTagModel.fromJson(e),
      )
          .toList(),

      isAvailable:
      json['isAvailable'] ?? true,

      isFavourite:
      json['isFavourite'] ?? false,
    );
  }

  String get imageUrl {
    if (images.isEmpty) return '';
    return images.first;
  }

  String get discountTag {
    if (tags.isEmpty) return '';

    // New API structure
    for (final tag in tags) {
      if (tag.tagName.isNotEmpty) {
        return tag.tagName;
      }
    }

    // Old API can sometimes return only
    // character indexes in tag object.
    return '';
  }
}

class ProductTagModel {
  final String icon;
  final String tagName;

  ProductTagModel({
    required this.icon,
    required this.tagName,
  });

  factory ProductTagModel.fromJson(
      Map<String, dynamic> json,
      ) {
    String icon =
        json['icon']?.toString() ?? '';

    String tagName =
        json['tagName']?.toString() ?? '';

    // Handles your first API tag:
    // {"0":"H","1":"o","2":"t"}
    if (tagName.isEmpty) {
      final buffer = StringBuffer();

      final keys = json.keys
          .where(
            (key) =>
        int.tryParse(key) != null,
      )
          .toList();

      keys.sort(
            (a, b) =>
            int.parse(a).compareTo(
              int.parse(b),
            ),
      );

      for (final key in keys) {
        buffer.write(json[key]);
      }

      tagName = buffer.toString();
    }

    return ProductTagModel(
      icon: icon,
      tagName: tagName,
    );
  }
}

class RestaurantModel {
  final String id;
  final String name;
  final String logo;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory RestaurantModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}