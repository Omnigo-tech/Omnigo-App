class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String logo;
  final String coverImage;
  final DeliveryTimeModel deliveryTime;
  final RatingModel rating;
  final bool isOpen;
  final double deliveryFee;
  final bool isFreeDelivery;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.coverImage,
    required this.deliveryTime,
    required this.rating,
    required this.isOpen,
    required this.deliveryFee,
    required this.isFreeDelivery,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      deliveryTime: DeliveryTimeModel.fromJson(
        json['deliveryTime'] is Map
            ? Map<String, dynamic>.from(json['deliveryTime'])
            : {},
      ),
      rating: RatingModel.fromJson(
        json['rating'] is Map
            ? Map<String, dynamic>.from(json['rating'])
            : {},
      ),
      isOpen: json['isOpen'] == true,
      deliveryFee: _toDouble(json['deliveryFee']),
      isFreeDelivery: json['isFreeDelivery'] == true,
    );
  }

  String get tags => description;

  String get deliveryInfo {
    final delivery =
        '${deliveryTime.min}-${deliveryTime.max} mins';

    if (isFreeDelivery) {
      return 'Free Delivery • $delivery';
    }

    return 'Delivery • $delivery';
  }

  double get averageRating => rating.average;

  int get reviewsCount => rating.count;

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}

class DeliveryTimeModel {
  final int min;
  final int max;

  DeliveryTimeModel({
    required this.min,
    required this.max,
  });

  factory DeliveryTimeModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DeliveryTimeModel(
      min: _toInt(json['min']),
      max: _toInt(json['max']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class RatingModel {
  final double average;
  final int count;

  RatingModel({
    required this.average,
    required this.count,
  });

  factory RatingModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RatingModel(
      average: _toDouble(json['average']),
      count: _toInt(json['count']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}


// =====================================================
// RESTAURANT CATEGORY
// =====================================================

class RestaurantCategoryModel {
  final String id;
  final String categoryName;

  RestaurantCategoryModel({
    required this.id,
    required this.categoryName,
  });

  factory RestaurantCategoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RestaurantCategoryModel(
      id: json['_id']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
    );
  }
}


// =====================================================
// MENU SECTION
// =====================================================

class FoodCategorySection {
  final String categoryTitle;
  final List<RestaurantFoodItemModel> items;

  FoodCategorySection({
    required this.categoryTitle,
    required this.items,
  });
}


// =====================================================
// FOOD ITEM
// =====================================================

class RestaurantFoodItemModel {
  final String id;
  final String name;
  final String description;
  final String price;
  final String image;
  final double? rating;

  RestaurantFoodItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.rating,
  });
}