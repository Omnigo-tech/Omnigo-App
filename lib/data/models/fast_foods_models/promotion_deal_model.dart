class PromotionDealModel {
  final String id;
  final String title;
  final String bannerImage;
  final PromotionRestaurantModel? restaurant;

  PromotionDealModel({
    required this.id,
    required this.title,
    required this.bannerImage,
    this.restaurant,
  });

  factory PromotionDealModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PromotionDealModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      bannerImage: json['bannerImage'] ?? '',
      restaurant: json['restaurantId'] is Map<String, dynamic>
          ? PromotionRestaurantModel.fromJson(
        json['restaurantId'] as Map<String, dynamic>,
      )
          : null,
    );
  }
}

// ============================================================
// RESTAURANT
// ============================================================

class PromotionRestaurantModel {
  final String id;
  final String name;
  final String logo;

  PromotionRestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory PromotionRestaurantModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PromotionRestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}

// ============================================================
// RESPONSE
// ============================================================

class PromotionDealResponseModel {
  final bool success;
  final int count;
  final List<PromotionDealModel> data;

  PromotionDealResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory PromotionDealResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PromotionDealResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.whereType<Map<String, dynamic>>()
          .map(
            (item) => PromotionDealModel.fromJson(item),
      )
          .toList() ??
          [],
    );
  }
}