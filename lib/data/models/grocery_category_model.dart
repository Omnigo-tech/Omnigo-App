import 'package:json_annotation/json_annotation.dart';

part 'grocery_category_model.g.dart';

@JsonSerializable()
class GroceryCategoryResponse {
  final bool success;
  final int count;
  final List<GroceryCategoryModel> data;

  GroceryCategoryResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GroceryCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$GroceryCategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroceryCategoryResponseToJson(this);
}

@JsonSerializable()
class GroceryCategoryModel {
  @JsonKey(name: '_id')
  final String id;

  final String categoryName;

  @JsonKey(defaultValue: [])
  final List<GrocerySubCategoryModel> subCategories;

  final String categorySlug;

  GroceryCategoryModel({
    required this.id,
    required this.categoryName,
    required this.subCategories,
    required this.categorySlug,
  });

  factory GroceryCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$GroceryCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroceryCategoryModelToJson(this);
}

@JsonSerializable()
class GrocerySubCategoryModel {
  @JsonKey(name: '_id')
  final String id;

  final String name;
  final String image;
  final String slug;
  final String? description;
  final int? sortOrder;
  final String? status;

  GrocerySubCategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.slug,
    this.description,
    this.sortOrder,
    this.status,
  });

  factory GrocerySubCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$GrocerySubCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$GrocerySubCategoryModelToJson(this);
}