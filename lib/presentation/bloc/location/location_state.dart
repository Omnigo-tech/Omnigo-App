// lib/presentation/bloc/location/location_state.dart

class ValueWrapper<T> {
  final T value;
  ValueWrapper(this.value);
}

class LocationState {
  final List<String> availableZones;
  final List<String> availableAreas;
  final String? selectedZone;
  final String? selectedArea;
  final bool isLoading;
  final String? errorMessage;
  final bool isGpsSuccess;

  LocationState({
    this.availableZones = const [],
    this.availableAreas = const [],
    this.selectedZone,
    this.selectedArea,
    this.isLoading = false,
    this.errorMessage,
    this.isGpsSuccess = false,
  });

  LocationState copyWith({
    List<String>? availableZones,
    List<String>? availableAreas,
    ValueWrapper<String?>? selectedZone, // Safe nullable dynamic wrappers
    ValueWrapper<String?>? selectedArea,
    bool? isLoading,
    String? errorMessage,
    bool? isGpsSuccess,
  }) {
    return LocationState(
      availableZones: availableZones ?? this.availableZones,
      availableAreas: availableAreas ?? this.availableAreas,
      selectedZone: selectedZone != null ? selectedZone.value : this.selectedZone,
      selectedArea: selectedArea != null ? selectedArea.value : this.selectedArea,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isGpsSuccess: isGpsSuccess ?? this.isGpsSuccess,
    );
  }
}