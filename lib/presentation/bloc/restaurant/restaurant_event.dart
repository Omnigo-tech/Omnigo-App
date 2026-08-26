import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object?> get props => [];
}


// =====================================================
// FETCH RESTAURANT
// =====================================================

class FetchRestaurantDetailsEvent extends RestaurantEvent {
  final String restaurantId;

  const FetchRestaurantDetailsEvent(
      this.restaurantId,
      );

  @override
  List<Object?> get props => [restaurantId];
}


// =====================================================
// CATEGORY TAB
// =====================================================

class ChangeCategoryTabEvent extends RestaurantEvent {
  final int selectedIndex;

  const ChangeCategoryTabEvent(
      this.selectedIndex,
      );

  @override
  List<Object?> get props => [selectedIndex];
}


// =====================================================
// SEE ALL CATEGORY
// =====================================================

class FetchCategoryProductsEvent extends RestaurantEvent {
  final String categoryName;

  const FetchCategoryProductsEvent(
      this.categoryName,
      );

  @override
  List<Object?> get props => [categoryName];
}