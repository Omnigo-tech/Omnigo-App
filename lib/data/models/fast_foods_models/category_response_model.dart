import 'fast_food_category_model.dart';

class CategoryResponseModel {
  final bool success;
  final List<CategoryModel> data;

  CategoryResponseModel({
    required this.success,
    required this.data,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic data = json['data'];

    return CategoryResponseModel(
      success: json['success'] == true,

      data: data is List
          ? data
          .whereType<Map>()
          .map(
            (item) => CategoryModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : [],
    );
  }
}