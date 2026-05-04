import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/data/models/tracking_model.dart';
import 'package:grocery_app/presentation/bloc/tracking/tracking_event.dart';
import 'package:grocery_app/presentation/bloc/tracking/tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  TrackingBloc() : super(TrackingInitial()) {
    on<FetchTrackingDetails>((event, emit) async {
      emit(TrackingLoading());
      try {
        // Simulating API call
        await Future.delayed(const Duration(seconds: 1));
        emit(TrackingLoaded(TrackingModel.mock()));
      } catch (e) {
        emit(TrackingError("Failed to fetch tracking details"));
      }
    });
  }
}
