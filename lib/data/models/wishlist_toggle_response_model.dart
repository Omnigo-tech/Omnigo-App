class WishlistToggleResponseModel{
  final bool success;
  final String message;
  final bool isFavorite;

  WishlistToggleResponseModel({
    required this.success,
    required this.message,
    required this.isFavorite,
});
  factory WishlistToggleResponseModel.fromJson(Map<String, dynamic> json) {
    return WishlistToggleResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}