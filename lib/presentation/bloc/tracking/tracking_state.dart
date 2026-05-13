import 'package:grocery_app/data/models/tracking_model.dart';

abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingLoaded extends TrackingState {
  final TrackingModel trackingModel;
  TrackingLoaded(this.trackingModel);
}

class TrackingError extends TrackingState {
  final String message;
  TrackingError(this.message);
}
