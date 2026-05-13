import 'package:grocery_app/data/models/address.dart';
import 'package:grocery_app/data/models/grocery-item.dart';

/*class OrderModel {
  final String id;
  final List<GroceryItemModel> items;
  final double total;
  final String status;
  final AddressModel address;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.address,
    required this.paymentMethod,
  });
}*/

class OrderModel {
  final String id;
  final List<GroceryItemModel> items;
  final double total;
  final String status; // pending, delivered, cancelled
  final AddressModel address;
  final String paymentMethod;
  final DateTime date;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.status,
    required this.address,
    required this.paymentMethod,
    required this.date,
  });
}
