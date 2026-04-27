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
              id: "2",
              name: "Fruit",
              image: ImageResource.FRUIT_IMAGE,
              weight: "1kg",
              price: 15.0,
              description: "Fresh Fruit.",
            ),
            GroceryItemModel(
              id: "3",
              name: "Meat",
              image: ImageResource.MEAT_IMG,
              weight: "1kg",
              price: 30.0,
              description: "Fresh Meat.",
            ),
            GroceryItemModel(
              id: "4",
              name: "Drink",
              image: ImageResource.DRINK_IMG,
              weight: "1kg",
              price: 5.0,
              description: "Fresh Drink.",
            ),
            GroceryItemModel(
              id: "5",
              name: "Dairy",
              image: ImageResource.BYKERY_IMG,
              weight: "1kg",
              price: 20.0,
              description: "Fresh Dairy.",
            ),
          ],
        ),
      );
    });
  }
}
