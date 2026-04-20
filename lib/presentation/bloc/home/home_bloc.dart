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
            {"title": "SOON", "image":""},
            {"title": "Rider", "image": ImageResource.BYKE_IMAGE},
            {"title": "Comfort", "image": ImageResource.COMFORT_IMAGE},
            {"title": "Courier", "image": ImageResource.COURIER_IMAGE},
            {"title": "Economy", "image": ImageResource.ECONOMY_IMAGE},
            {"title": "Ricksha", "image": ImageResource.RICKSHAW_IMAGE},
          ],
          [
            GroceryItemModel(
              id: "1",
              name: "Vegetables",
              image: ImageResource.VEGETABLE_IMAGE,
              weight: "1kg",
              description: "Ginger is a flowering plant whose rhizome, ginger root or ginger, is widely used as a spice and a folk medicine.",
            ),
            GroceryItemModel(
              id: "2",
              name: "Fruits",
              weight: "1kg",
              image: ImageResource.FRUIT_IMAGE,
              description: "Ginger is a flowering plant whose rhizome, ginger root or ginger, is widely used as a spice and a folk medicine.",
            ),
            GroceryItemModel(
              id: "3",
              name: "Vegetables",
              weight: "1kg",
              image: ImageResource.VEGETABLE_IMAGE,
              description: "Ginger is a flowering plant whose rhizome, ginger root or ginger, is widely used as a spice and a folk medicine.",
            ),
            GroceryItemModel(
              id: "4",
              name: "Fruits",
              weight: "1kg",
              image: ImageResource.FRUIT_IMAGE,
              description: "Ginger is a flowering plant whose rhizome, ginger root or ginger, is widely used as a spice and a folk medicine.",
            ),
          ],
        ),
      );
    });
  }
}