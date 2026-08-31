

import 'address_response_model.dart';
import 'grocery-item.dart';

class OrderDetailResponseModel {
  final bool success;
  final OrderDetailModel? order;

  OrderDetailResponseModel({required this.success, this.order});

  factory OrderDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponseModel(
      success: json['success'] ?? false,
      order: json['order'] != null ? OrderDetailModel.fromJson(json['order']) : null,
    );
  }
}

class OrderDetailModel {
  final String orderId;
  final String orderNumber;
  final CustomerModel? customer;
  final RiderModel? rider;
  final ServerAddressModel? address;
  final List<GroceryItemModel> items;
  final String paymentMethod;
  final String paymentStatus;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double promoDiscount;
  final double totalAmount;
  final String status;
  final bool isAssigned;
  final DateTime? createdAt;

  OrderDetailModel({
    required this.orderId,
    required this.orderNumber,
    this.customer,
    this.rider,
    this.address,
    required this.items,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.promoDiscount,
    required this.totalAmount,
    required this.status,
    required this.isAssigned,
    this.createdAt,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      orderId: json['orderId'] ?? json['_id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      customer: json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null,
      rider: json['rider'] != null ? RiderModel.fromJson(json['rider']) : null,
      address: json['address'] != null
          ? ServerAddressModel.fromJson({
        ...json['address'],
        '_id': json['address']['addressId'] ?? '',
      })
          : null,
      items: (json['items'] as List?)
          ?.map((item) => GroceryItemModel(
        id: item['productId'] ?? '',
        name: item['name'] ?? '',
        image: item['image'] ?? '',
        price: (item['price'] as num?)?.toDouble() ?? 0.0,
        quantity: item['quantity'] ?? 1,
        weight: item['weight'] ?? '',
        belongsTo: item['belongsTo'] ?? '',
        description: '',
      ))
          .toList() ?? [],
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      promoDiscount: (json['promoDiscount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',
      isAssigned: json['isAssigned'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}

class CustomerModel {
  final String id;
  final String name;
  final String email;
  final String phone;

  CustomerModel({required this.id, required this.name, required this.email, required this.phone});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class RiderModel {
  final String id;
  final String name;
  final String email;
  final String phone;

  RiderModel({required this.id, required this.name, required this.email, required this.phone});

  factory RiderModel.fromJson(Map<String, dynamic> json) {
    return RiderModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}