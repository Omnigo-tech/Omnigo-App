class GroceryItemModel {
  final String id;
  final String name;
  String? weight;
  final String image;
  final String description;

  bool isFavorite;
  int quantity;

  GroceryItemModel({
    required this.id,
    required this.name,
    required this.image,
    this.weight,
    required this.description,
    this.isFavorite = false,
    this.quantity = 1,
  });

  GroceryItemModel copyWith({
    bool? isFavorite,
    int? quantity,
  }) {
    return GroceryItemModel(
      id: id,
      name: name,
      image: image,
      description: description,
      weight: weight,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: quantity ?? this.quantity,
    );
  }
}