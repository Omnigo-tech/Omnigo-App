// lib/presentation/bloc/location/location_event.dart
abstract class LocationEvent {}

class LoadInitialDataEvent extends LocationEvent {}

class ChangeZoneEvent extends LocationEvent {
  final String selectedZone;
  ChangeZoneEvent(this.selectedZone);
}

class ChangeAreaEvent extends LocationEvent {
  final String selectedArea;
  ChangeAreaEvent(this.selectedArea);
}

class FetchGpsLocationEvent extends LocationEvent {}