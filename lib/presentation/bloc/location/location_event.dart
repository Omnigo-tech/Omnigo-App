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

class SubmitManualLocationEvent extends LocationEvent {
  final String zone;
  final String area;
  final String address;

  SubmitManualLocationEvent({
    required this.zone,
    required this.area,
    required this.address,
  });
}

class FetchGpsLocationEvent extends LocationEvent {}