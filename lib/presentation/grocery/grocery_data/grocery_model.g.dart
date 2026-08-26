// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroceryModel _$GroceryModelFromJson(Map<String, dynamic> json) => GroceryModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  images:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  price: (json['price'] as num).toDouble(),
  description: json['description'] as String?,
  weight: json['weight'] as String?,
  subcategory: json['subcategory'] as String?,
  discountPrice: (json['discountPrice'] as num?)?.toDouble(),
  isAvailable: json['isAvailable'] as bool? ?? true,
  isFavourite: json['isFavourite'] as bool? ?? false,
);

Map<String, dynamic> _$GroceryModelToJson(GroceryModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'images': instance.images,
      'price': instance.price,
      'description': instance.description,
      'weight': instance.weight,
      'subcategory': instance.subcategory,
      'discountPrice': instance.discountPrice,
      'isAvailable': instance.isAvailable,
      'isFavourite': instance.isFavourite,
    };
