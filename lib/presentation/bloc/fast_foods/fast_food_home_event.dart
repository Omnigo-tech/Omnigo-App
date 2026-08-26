part of 'fast_food_home_bloc.dart';

abstract class FastFoodHomeEvent {}

// ============================================================
// LOAD HOME
// ============================================================

class LoadCategoryDataEvent
    extends FastFoodHomeEvent {}

// ============================================================
// MAIN CATEGORY SELECT
// ============================================================

class SelectMainCategoryEvent
    extends FastFoodHomeEvent {

  final String categoryId;
  final int selectedIndex;

  SelectMainCategoryEvent({
    required this.categoryId,
    required this.selectedIndex,
  });
}

// ============================================================
// SUBCATEGORY SELECT
// ============================================================

class SelectSubCategoryEvent
    extends FastFoodHomeEvent {

  final String subCategoryId;
  final int selectedCategoryIndex;

  SelectSubCategoryEvent({
    required this.subCategoryId,
    required this.selectedCategoryIndex,
  });
}