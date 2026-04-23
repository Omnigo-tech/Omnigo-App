// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

import 'grocery_model.dart';

GroceryModel _$GroceryModelFromJson(Map<String, dynamic> json) => GroceryModel(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  image: json['image'] as String,
  price: (json['price'] as num).toDouble(),
  description: json['description'] as String?,
  weight: json['weight'] as String?,
);

Map<String, dynamic> _$GroceryModelToJson(GroceryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'image': instance.image,
      'price': instance.price,
      'description': instance.description,
      'weight': instance.weight,
    };
