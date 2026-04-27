import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constants/images-resources.dart';
import '../../../data/models/grocery-item.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<LoadHomeData>((event, emit) async {
      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        HomeLoaded(
          [
            {"title": "SOON", "image": ""}, // Index 0
            {"title": "SOON", "image": ""}, // Index 1
            {
              "title": "Comfort",
              "image": ImageResource.COMFORT_IMAGE,
            }, // Index 2
            {"title": "Rider", "image": ImageResource.BYKE_IMAGE}, // Index 3
            {
              "title": "Economy",
              "image": ImageResource.ECONOMY_IMAGE,
            }, // Index 4
            {
              "title": "Couriers",
              "image": ImageResource.COURIER_IMAGE,
            }, // Index 5
            {
              "title": "Rickshaw",
              "image": ImageResource.RICKSHAW_IMAGE,
            }, // Index 6
            {"title": "SOON", "image": ""}, // Index 7
          ],
          [
            GroceryItemModel(
              id: "1",
              name: "Vegetables",
              image: ImageResource.VEGETABLE_IMAGE,
              weight: "1kg",
              price: 20.0,
              description: "Fresh vegetables.",
            ),
          ],
        ),
      );
    });
  }
}
