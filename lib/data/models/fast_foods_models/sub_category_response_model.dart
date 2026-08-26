import 'fast_food_category_model.dart';

class SubCategoryResponseModel {
  final bool success;
  final List<SubCategoryModel> data;

  SubCategoryResponseModel({
    required this.success,
    required this.data,
  });

  factory SubCategoryResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final dynamic data = json['data'];

    return SubCategoryResponseModel(
      success: json['success'] == true,

      data: data is List
          ? data
          .whereType<Map>()
          .map(
            (item) => SubCategoryModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList()
          : [],
    );
  }
}