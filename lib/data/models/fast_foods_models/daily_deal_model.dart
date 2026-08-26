import 'fast_delivery_restaurant_model.dart';

class DailyDealsResponseModel {
  final bool success;
  final int count;
  final List<DailyDealModel> data;

  DailyDealsResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory DailyDealsResponseModel.fromJson(Map<String, dynamic> json) {
    return DailyDealsResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: json['data'] != null
          ? List<DailyDealModel>.from(
        json['data'].map((x) => DailyDealModel.fromJson(x)),
      )
          : [],
    );
  }
}

class DailyDealModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final DealRestaurantModel? restaurant;
  final num originalPrice;
  final num discountPrice;
  final String dealType;

  DailyDealModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    this.restaurant,
    required this.originalPrice,
    required this.discountPrice,
    required this.dealType,
  });

  factory DailyDealModel.fromJson(Map<String, dynamic> json) {
    return DailyDealModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      restaurant: json['restaurantId'] != null
          ? DealRestaurantModel.fromJson(json['restaurantId'])
          : null,
      originalPrice: json['originalPrice'] ?? 0,
      discountPrice: json['discountPrice'] ?? 0,
      dealType: json['dealType'] ?? '',
    );
  }
}

class DealRestaurantModel {
  final String id;
  final String name;
  final String logo;
  final num deliveryFee;
  final DeliveryTimeModel? deliveryTime;
  final RatingModel? rating;

  DealRestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.deliveryFee,
    this.deliveryTime,
    this.rating,
  });

  factory DealRestaurantModel.fromJson(Map<String, dynamic> json) {
    return DealRestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      deliveryFee: json['deliveryFee'] ?? 0,
      deliveryTime: json['deliveryTime'] != null
          ? DeliveryTimeModel.fromJson(json['deliveryTime'])
          : null,
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
    );
  }
}