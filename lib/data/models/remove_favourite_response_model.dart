class RemoveFavouriteResponseModel {
  final bool success;
  final String message;
  final List<String> favorites;

  RemoveFavouriteResponseModel({
    required this.success,
    required this.message,
    required this.favorites,
  });

  factory RemoveFavouriteResponseModel.fromJson(
      Map<String, dynamic> json) {
    return RemoveFavouriteResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      favorites: List<String>.from(
        json['favorites'] ?? [],
      ),
    );
  }
}