import 'package:grocery_app/data/models/fast_foods_models/promotion_deal_model.dart';

class DealDetailResponseModel {
  final bool success;
  final DealDetailModel data;

  DealDetailResponseModel({
    required this.success,
    required this.data,
  });

  factory DealDetailResponseModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DealDetailResponseModel(
      success: json['success'] ?? false,
      data: DealDetailModel.fromJson(
        json['data'] ?? {},
      ),
    );
  }
}

class DealDetailModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String bannerImage;
  final PromotionRestaurantModel restaurant;
  final String dealType;
  final String tag;
  final DealPricingModel pricing;
  final List<DealProductModel> products;
  final DateTime? validFrom;
  final DateTime? validUntil;

  DealDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.bannerImage,
    required this.restaurant,
    required this.dealType,
    required this.tag,
    required this.pricing,
    required this.products,
    this.validFrom,
    this.validUntil,
  });

  factory DealDetailModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DealDetailModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      bannerImage: json['bannerImage'] ?? '',
      restaurant: PromotionRestaurantModel.fromJson(
        json['restaurant'] ?? {},
      ),
      dealType: json['dealType'] ?? '',
      tag: json['tag'] ?? '',
      pricing: DealPricingModel.fromJson(
        json['pricing'] ?? {},
      ),
      products: (json['products'] as List? ?? [])
          .map(
            (e) => DealProductModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
          .toList(),
      validFrom: json['validFrom'] != null
          ? DateTime.tryParse(json['validFrom'])
          : null,
      validUntil: json['validUntil'] != null
          ? DateTime.tryParse(json['validUntil'])
          : null,
    );
  }
}
class DealPricingModel {
  final double originalPrice;
  final double discountPrice;
  final double amountSaved;
  final double itemsSubtotal;

  DealPricingModel({
    required this.originalPrice,
    required this.discountPrice,
    required this.amountSaved,
    required this.itemsSubtotal,
  });

  factory DealPricingModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DealPricingModel(
      originalPrice:
      (json['originalPrice'] ?? 0).toDouble(),
      discountPrice:
      (json['discountPrice'] ?? 0).toDouble(),
      amountSaved:
      (json['amountSaved'] ?? 0).toDouble(),
      itemsSubtotal:
      (json['itemsSubtotal'] ?? 0).toDouble(),
    );
  }
}

class DealProductModel {
  final String productId;
  final String name;
  final String image;
  final String category;
  final double price;
  final int quantity;
  final double total;

  DealProductModel({
    required this.productId,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory DealProductModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return DealProductModel(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      total: (json['total'] ?? 0).toDouble(),
    );
  }
}