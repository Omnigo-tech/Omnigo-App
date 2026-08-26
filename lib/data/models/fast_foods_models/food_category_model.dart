class FoodCategoryModel {
  final String? id;
  final String title;
  final String imageUrl;

  FoodCategoryModel({
     this.id,
    required this.title,
    required this.imageUrl,
  });

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class FoodItemModel {
  final String id;
  final String name;
  final String restaurantName;
  final double rating;
  final int? ratingCount;
  final double price;
  final String imageUrl;
  final String? discountTag;
  final String restaurantLogo;


  FoodItemModel({
    required this.id,
    required this.name,
    required this.restaurantName,
    required this.rating,
    this.ratingCount,
    required this.price,
    required this.imageUrl,
    required this.restaurantLogo,
    this.discountTag,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      restaurantLogo: json['restaurantLogo'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      ratingCount: json['ratingCount'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      discountTag: json['discountTag'],
    );
  }
}