class PopularProductsResponseModel {
  final bool success;
  final int count;
  final List<PopularProductModel> data;

  PopularProductsResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory PopularProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return PopularProductsResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: json['data'] != null
          ? List<PopularProductModel>.from(
        json['data'].map((x) => PopularProductModel.fromJson(x)),
      )
          : [],
    );
  }
}

class PopularProductModel {
  final String id;
  final String name;
  final List<String> images;
  final num price;
  final num discountPrice;
  final RatingModel? rating;
  final PopularRestaurantModel? restaurant;

  PopularProductModel({
    required this.id,
    required this.name,
    required this.images,
    required this.price,
    required this.discountPrice,
    this.rating,
    this.restaurant,
  });

  factory PopularProductModel.fromJson(Map<String, dynamic> json) {
    return PopularProductModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      price: json['price'] ?? 0,
      discountPrice: json['discountPrice'] ?? 0,
      rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
      restaurant: json['restaurant'] != null
          ? PopularRestaurantModel.fromJson(json['restaurant'])
          : null,
    );
  }
}

class PopularRestaurantModel {
  final String id;
  final String name;
  final String logo;

  PopularRestaurantModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory PopularRestaurantModel.fromJson(Map<String, dynamic> json) {
    return PopularRestaurantModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
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