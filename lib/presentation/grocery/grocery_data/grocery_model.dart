import 'package:json_annotation/json_annotation.dart';
part 'grocery_model.g.dart';

@JsonSerializable()
class GroceryModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'category')
  final String category;
  @JsonKey(name: 'image')
  final String image;
  @JsonKey(name: 'price')
  final double price;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'weight')
  final String? weight;

  GroceryModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
    this.description,
    this.weight,
  });

  factory GroceryModel.fromJson(Map<String, dynamic> json) => _$GroceryModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroceryModelToJson(this);
}
