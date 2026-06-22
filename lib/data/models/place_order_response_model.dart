class PlaceOrderResponseModel {
  final bool success;
  final String message;

  PlaceOrderResponseModel({
    required this.success,
    required this.message,
  });

  factory PlaceOrderResponseModel.fromJson(
      Map<String, dynamic> json) {
    return PlaceOrderResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}