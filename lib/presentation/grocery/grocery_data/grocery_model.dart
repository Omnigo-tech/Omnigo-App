import 'package:json_annotation/json_annotation.dart';

part 'grocery_model.g.dart';

@JsonSerializable()
class GroceryModel {
  @JsonKey(name: '_id')
  final String id;

  final String name;

  final String category;

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

  factory GroceryModel.fromJson(Map<String, dynamic> json) {
    return GroceryModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',

      // null / invalid images ko empty list bana do
      images: json['images'] is List
          ? (json['images'] as List)
          .where((e) => e != null)
          .map((e) => e.toString())
          .toList()
          : [],

      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,

      description: json['description']?.toString(),
      weight: json['weight']?.toString(),
      subcategory: json['subcategory']?.toString(),

      discountPrice: json['discountPrice'] is num
          ? (json['discountPrice'] as num).toDouble()
          : null,

      isAvailable: json['isAvailable'] is bool
          ? json['isAvailable'] as bool
          : true,

      isFavourite: json['isFavourite'] is bool
          ? json['isFavourite'] as bool
          : false,
    );
  }

  Map<String, dynamic> toJson() => _$GroceryModelToJson(this);
}