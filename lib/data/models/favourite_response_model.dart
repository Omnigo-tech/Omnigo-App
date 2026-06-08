import 'grocery-item.dart';

class FavoriteResponse {
  final bool success;
  final int total;
  final List<GroceryItemModel> favorites;

  FavoriteResponse({
    required this.success,
    required this.total,
    required this.favorites,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) {
    return FavoriteResponse(
      success: json['success'] ?? false,
      total: json['total'] ?? 0,
      favorites: (json['favorites'] as List)
          .map((e) => GroceryItemModel.fromJson(e))
          .toList(),
    );
  }
}