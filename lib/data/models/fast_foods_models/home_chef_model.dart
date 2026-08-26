class HomeChefResponseModel {
  final bool success;
  final int count;
  final List<HomeChefModel> chefs;

  HomeChefResponseModel({
    required this.success,
    required this.count,
    required this.chefs,
  });

  factory HomeChefResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeChefResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      chefs: (json['chefs'] as List<dynamic>?)
          ?.map((e) => HomeChefModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class HomeChefModel {
  final String id;
  final String name;
  final String description;
  final String logo;
  final String coverImage;
  final double deliveryFee;
  final String offer;
  final int minDeliveryTime;
  final int maxDeliveryTime;
  final double ratingAverage;
  final int ratingCount;

  HomeChefModel({
    required this.id,
    required this.name,
    required this.description,
    required this.logo,
    required this.coverImage,
    required this.deliveryFee,
    required this.offer,
    required this.minDeliveryTime,
    required this.maxDeliveryTime,
    required this.ratingAverage,
    required this.ratingCount,
  });

  factory HomeChefModel.fromJson(Map<String, dynamic> json) {
    final deliveryTime = json['deliveryTime'] as Map<String, dynamic>?;
    final rating = json['rating'] as Map<String, dynamic>?;

    return HomeChefModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'] ?? '',
      coverImage: json['coverImage'] ?? '',
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      offer: json['offer'] ?? '',
      minDeliveryTime: deliveryTime?['min'] ?? 0,
      maxDeliveryTime: deliveryTime?['max'] ?? 0,
      ratingAverage: (rating?['average'] ?? 0).toDouble(),
      ratingCount: rating?['count'] ?? 0,
    );
  }
}