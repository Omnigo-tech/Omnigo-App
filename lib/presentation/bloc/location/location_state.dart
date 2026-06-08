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
  final String? detectedAddress;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final bool isGpsSuccess;

  LocationState({
    this.availableZones = const [],
    this.availableAreas = const [],
    this.selectedZone,
    this.selectedArea,
    this.detectedAddress,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.isGpsSuccess = false,
  });

  LocationState copyWith({
    List<String>? availableZones,
    List<String>? availableAreas,
    ValueWrapper<String?>? selectedZone, // Safe nullable dynamic wrappers
    ValueWrapper<String?>? selectedArea,
    ValueWrapper<String?>? detectedAddress,
    bool? isLoading,
    ValueWrapper<String?>? errorMessage,
    ValueWrapper<String?>? successMessage,
    bool? isGpsSuccess,
  }) {
    return LocationState(
      availableZones: availableZones ?? this.availableZones,
      availableAreas: availableAreas ?? this.availableAreas,
      selectedZone: selectedZone != null ? selectedZone.value : this.selectedZone,
      selectedArea: selectedArea != null ? selectedArea.value : this.selectedArea,
      detectedAddress: detectedAddress != null ? detectedAddress.value : this.detectedAddress,
      errorMessage: errorMessage != null ? errorMessage.value : this.errorMessage,
      successMessage: successMessage != null ? successMessage.value : this.successMessage,
      isGpsSuccess: isGpsSuccess ?? this.isGpsSuccess,
    );
  }
}