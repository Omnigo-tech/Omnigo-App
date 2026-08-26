// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grocery_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroceryCategoryResponse _$GroceryCategoryResponseFromJson(
  Map<String, dynamic> json,
) => GroceryCategoryResponse(
  success: json['success'] as bool,
  count: (json['count'] as num).toInt(),
  data: (json['data'] as List<dynamic>)
      .map((e) => GroceryCategoryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GroceryCategoryResponseToJson(
  GroceryCategoryResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'count': instance.count,
  'data': instance.data,
};

GroceryCategoryModel _$GroceryCategoryModelFromJson(
  Map<String, dynamic> json,
) => GroceryCategoryModel(
  id: json['_id'] as String,
  categoryName: json['categoryName'] as String,
  subCategories:
      (json['subCategories'] as List<dynamic>?)
          ?.map(
            (e) => GrocerySubCategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
  categorySlug: json['categorySlug'] as String,
);

Map<String, dynamic> _$GroceryCategoryModelToJson(
  GroceryCategoryModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'categoryName': instance.categoryName,
  'subCategories': instance.subCategories,
  'categorySlug': instance.categorySlug,
};

GrocerySubCategoryModel _$GrocerySubCategoryModelFromJson(
  Map<String, dynamic> json,
) => GrocerySubCategoryModel(
  id: json['_id'] as String,
  name: json['name'] as String,
  image: json['image'] as String,
  slug: json['slug'] as String,
  description: json['description'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt(),
  status: json['status'] as String?,
);

Map<String, dynamic> _$GrocerySubCategoryModelToJson(
  GrocerySubCategoryModel instance,
) => <String, dynamic>{
  '_id': instance.id,
  'name': instance.name,
  'image': instance.image,
  'slug': instance.slug,
  'description': instance.description,
  'sortOrder': instance.sortOrder,
  'status': instance.status,
};
