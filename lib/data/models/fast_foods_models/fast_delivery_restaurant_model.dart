class FastDeliveryResponseModel {
  final bool success;
  final int count;
  final List<FastDeliveryRestaurantModel> fastDeliveryRestaurants;

  FastDeliveryResponseModel({
    required this.success,
    required this.count,
    required this.fastDeliveryRestaurants,
  });

  factory FastDeliveryResponseModel.fromJson(Map<String, dynamic> json) {
    return FastDeliveryResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      fastDeliveryRestaurants: json['fastDeliveryRestaurants'] != null
          ? List<FastDeliveryRestaurantModel>.from(
        json['fastDeliveryRestaurants']
            .map((x) => FastDeliveryRestaurantModel.fromJson(x)),
      )
          : [],
    );
  }
}

class FastDeliveryRestaurantModel {
  final String id;
  final String name;
  final String logo;
  final String coverImage;
  final DeliveryTimeModel deliveryTime;
  final RatingModel rating;
  final OfferModel? offer;

  FastDeliveryRestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.coverImage,
    required this.deliveryTime,
    required this.rating,
    this.offer,
  });

  factory FastDeliveryRestaurantModel.fromJson(Map<String, dynamic> json) {
    return FastDeliveryRestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      coverImage: json['coverImage'] ?? '',
      deliveryTime: DeliveryTimeModel.fromJson(json['deliveryTime'] ?? {}),
      rating: RatingModel.fromJson(json['rating'] ?? {}),
      offer: json['offer'] != null ? OfferModel.fromJson(json['offer']) : null,
    );
  }
}

class DeliveryTimeModel {
  final int min;
  final int max;

  DeliveryTimeModel({required this.min, required this.max});

  factory DeliveryTimeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryTimeModel(
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
    );
  }
}

class RatingModel {
  final num average;
  final int count;

  RatingModel({required this.average, required this.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average'] ?? 0,
      count: json['count'] ?? 0,
    );
  }
}

class OfferModel {
  final String title;
  final String icon;

  OfferModel({required this.title, required this.icon});

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}