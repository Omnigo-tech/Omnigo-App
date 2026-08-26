import 'package:json_annotation/json_annotation.dart';

import '../../presentation/grocery/grocery_data/grocery_model.dart';

part 'products_response_model.g.dart';

@JsonSerializable()
class ProductsResponseModel {
  final bool success;
  final int count;
  final List<GroceryModel> data;

  ProductsResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseModelToJson(this);
}