import 'package:json_annotation/json_annotation.dart';

part 'grocery_model.g.dart';

@JsonSerializable()
class GroceryModel {
  @JsonKey(name: '_id')
  final String id;

  final String name;

  final String category;

  @JsonKey(defaultValue: [])
  final List<String> images;

  final double price;

  final String? description;
  final String? weight;
  final String? subcategory;
  final double? discountPrice;

  @JsonKey(defaultValue: true)
  final bool isAvailable;

  @JsonKey(defaultValue: false)
  final bool isFavourite;

  GroceryModel({
    required this.id,
    required this.name,
    required this.category,
    this.images = const [],
    required this.price,
    this.description,
    this.weight,
    this.subcategory,
    this.discountPrice,
    this.isAvailable = true,
    this.isFavourite = false,
  });

  String? get image {
    if (images.isEmpty) return null;
    return images.first;
  }

  factory GroceryModel.fromJson(Map<String, dynamic> json) =>
      _$GroceryModelFromJson(json);

  Map<String, dynamic> toJson() => _$GroceryModelToJson(this);
}