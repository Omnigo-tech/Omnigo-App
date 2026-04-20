import '../../../data/models/grocery-item.dart';

abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, String>> services;
  final List<GroceryItemModel> categories;
  HomeLoaded(this.services, this.categories);
}