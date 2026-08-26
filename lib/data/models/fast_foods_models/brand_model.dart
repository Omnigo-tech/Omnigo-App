class BrandResponseModel {
  final bool success;
  final int count;
  final List<BrandModel> restaurants;

  BrandResponseModel({
    required this.success,
    required this.count,
    required this.restaurants,
  });

  factory BrandResponseModel.fromJson(Map<String, dynamic> json) {
    return BrandResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      restaurants: (json['restaurants'] as List<dynamic>?)
          ?.map((e) => BrandModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class BrandModel {
  final String id;
  final String name;
  final String logo;

  BrandModel({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
    );
  }
}