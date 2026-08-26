class CategoryModel {
  final String id;
  final String categoryName;
  final String? categorySlug;
  final String? description;
  final String? image;
  final String? icon;
  final List<SubCategoryModel> subCategories;
  final int sortOrder;
  final String? status;
  final bool isFeatured;

  CategoryModel({
    required this.id,
    required this.categoryName,
    this.categorySlug,
    this.description,
    this.image,
    this.icon,
    required this.subCategories,
    required this.sortOrder,
    this.status,
    required this.isFeatured,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      categorySlug: json['categorySlug']?.toString(),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      icon: json['icon']?.toString(),

      subCategories: (json['subCategories'] as List<dynamic>?)
          ?.whereType<Map>()
          .map(
            (item) => SubCategoryModel.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList() ??
          [],

      sortOrder: json['sortOrder'] is int
          ? json['sortOrder']
          : int.tryParse(json['sortOrder']?.toString() ?? '') ?? 0,

      status: json['status']?.toString(),

      isFeatured: json['isFeatured'] == true,
    );
  }
}

class SubCategoryModel {
  final String id;
  final String name;
  final String slug;
  final String? image;
  final String? description;
  final int sortOrder;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
    this.description,
    required this.sortOrder,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      image: json['image']?.toString(),
      description: json['description']?.toString(),

      sortOrder: json['sortOrder'] is int
          ? json['sortOrder']
          : int.tryParse(json['sortOrder']?.toString() ?? '') ?? 0,

      status: json['status']?.toString(),

      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }
}