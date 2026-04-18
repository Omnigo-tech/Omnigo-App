import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/constants/images-resources.dart';
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
            {"title": "Vegetables", "image": ImageResource.VEGETABLE_IMAGE},
            {"title": "Fruits", "image": ImageResource.FRUIT_IMAGE},
            {"title": "Vegetables", "image": ImageResource.VEGETABLE_IMAGE},
            {"title": "Fruits", "image": ImageResource.FRUIT_IMAGE},
            {"title": "Vegetables", "image": ImageResource.VEGETABLE_IMAGE},

          ],
        ),
      );
    });
  }
}