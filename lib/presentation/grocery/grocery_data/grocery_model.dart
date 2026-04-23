class GroceryModel {
  final String id;
  final String name;
  final String category;
  final String image;
  final double price;
  final String? description;
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
}
