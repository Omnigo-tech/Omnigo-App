import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constants/images-resources.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeLoading()) {
    on<LoadHomeData>((event, emit) async {
      emit(
        HomeLoaded(
          [
            {"title": "SOON", "image": ""},
            {"title": "SOON", "image": ""},
            {
              "title": "Comfort",
              "image": ImageResource.COMFORT_IMAGE,
            },
            {
              "title": "Rider",
              "image": ImageResource.BYKE_IMAGE,
            },
            {
              "title": "Economy",
              "image": ImageResource.ECONOMY_IMAGE,
            },
            {
              "title": "Couriers",
              "image": ImageResource.COURIER_IMAGE,
            },
            {
              "title": "Rickshaw",
              "image": ImageResource.RICKSHAW_IMAGE,
            },
            {"title": "SOON", "image": ""},
          ],

          // Grocery dummy data remove
          [],
        ),
      );
    });
  }
}