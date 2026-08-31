import 'grocery-item.dart';

class RemoveFavouriteResponseModel {
  final bool success;
  final String message;
  final List<GroceryItemModel> favorites;

  RemoveFavouriteResponseModel({
    required this.success,
    required this.message,
    required this.favorites,
  });

  factory RemoveFavouriteResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RemoveFavouriteResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      favorites: (json['favorites'] as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(GroceryItemModel.fromJson)
          .toList(),
    );
  }
}