import 'package:grocery_app/data/models/address.dart';
import 'package:grocery_app/data/models/grocery-item.dart';

class OrderModel {
  final String? id;
  final String? orderNumber;
  final String? riderId;
  final bool? isAssigned;
  final DateTime? acceptedAt;
  final List<GroceryItemModel>? items;
  final double? subtotal;
  final double? deliveryFee;
  final double? tax;
  final double? promoDiscount;
  final double? total;
  final String? status;
  final String? paymentMethod;
  final String? paymentStatus;
  final AddressModel? address;
  final DateTime? date;
  final DateTime? updatedAt;

  OrderModel({
     this.id,
    this.orderNumber,
    this.riderId,
    this.isAssigned,
    this.acceptedAt,
     this.items,
     this.subtotal,
     this.deliveryFee,
     this.tax,
     this.promoDiscount,
     this.total,
     this.status,
     this.paymentMethod,
     this.paymentStatus,
     this.address,
     this.date,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      riderId: json['riderId'] ?? '',
      isAssigned: json['isAssigned'] ?? false,
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'])
          : null,
      status: json['status'] ?? 'pending',
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      promoDiscount:
      (json['promoDiscount'] as num?)?.toDouble() ?? 0.0,
      total: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      date: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      address: AddressModel.fromJson(json['address'] ?? {}),
      items: (json['items'] as List?)
          ?.map(
            (item) => GroceryItemModel(
          id: item['productId'] ?? '',
          name: item['name'] ?? '',
          image: item['image'] ?? '',
          price:
          (item['price'] as num?)?.toDouble() ?? 0.0,
          quantity: item['quantity'] ?? 1,
          weight: item['weight'] ?? '',
          description: '',
        ),
      )
          .toList() ??
          [],
    );
  }
}