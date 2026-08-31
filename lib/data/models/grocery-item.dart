import 'package:equatable/equatable.dart';

class GroceryItemModel extends Equatable {
  final String id;
  final String name;
  final String? weight;
  final String image;
  final String description;
  final double price;
  final bool isFavorite;
  final int quantity;
  final String belongsTo;

  const GroceryItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.weight,
    required this.description,
    this.isFavorite = false,
    this.quantity = 1,
    required this.belongsTo,
  });

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    return GroceryItemModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      weight: json['weight']?.toString(),

      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price']?.toString() ?? '') ?? 0.0,

      quantity: json['quantity'] is num
          ? (json['quantity'] as num).toInt()
          : 1,

      belongsTo: json['belongsTo']?.toString() ?? 'grocery',

      isFavorite: json['isFavourite'] == true ||
          json['isFavorite'] == true,
    );
  }

  GroceryItemModel copyWith({
    bool? isFavorite,
    int? quantity,
    double? price,
    String? belongsTo,
  }) {
    return GroceryItemModel(
      id: id,
      name: name,
      image: image,
      description: description,
      weight: weight,
      price: price ?? this.price,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: quantity ?? this.quantity,
      belongsTo: belongsTo ?? this.belongsTo,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    weight,
    image,
    description,
    price,
    isFavorite,
    quantity,
    belongsTo,
  ];
}