enum ListingType {
  brands,
  popularItems,
  homeChefs,
  fastDelivery;

  /// Optional: Helper getter to get default titles if needed
  String get title {
    switch (this) {
      case ListingType.brands:
        return 'All Restaurants';
      case ListingType.popularItems:
        return 'Popular Items';
      case ListingType.homeChefs:
        return 'Every Meal Feels Like Home';
      case ListingType.fastDelivery:
        return 'Quick Delivery';
    }
  }
}