abstract class HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, String>> services;
  final List<Map<String, String>> categories;
  HomeLoaded(this.services, this.categories);
}