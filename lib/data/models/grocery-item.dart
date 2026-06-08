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

  const GroceryItemModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.weight,
    required this.description,
    this.isFavorite = false,
    this.quantity = 1,
  });

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    return GroceryItemModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
      weight: json['weight'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,

      // Wishlist API se aane wale items already favorite hain
      isFavorite: true,
    );
  }

  GroceryItemModel copyWith({
    bool? isFavorite,
    int? quantity,
    double? price,
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
  ];
}