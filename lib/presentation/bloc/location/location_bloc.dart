import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _repository;

  LocationBloc(this._repository) : super(LocationState()) {

    // 1. Initial Load
    on<LoadInitialDataEvent>((event, emit) {
      final zones = _repository.getStaticZones();
      emit(state.copyWith(availableZones: zones));
    });

    // 2. Manual Zone Change
    on<ChangeZoneEvent>((event, emit) {
      final areas = _repository.getStaticAreas(event.selectedZone);
      emit(state.copyWith(
        selectedZone: ValueWrapper(event.selectedZone),
        selectedArea: ValueWrapper(null), // Naya zone aane par area reset
        availableAreas: areas,
      ));
    });

    // 3. Manual Area Change
    on<ChangeAreaEvent>((event, emit) {
      emit(state.copyWith(
        selectedArea: ValueWrapper(event.selectedArea),
      ));
    });

    on<FetchGpsLocationEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final address = await _repository.fetchGpsLocation();
        if (address != null) {
          String detectedCity = address['city']!.trim();
          String detectedArea = address['area']!.trim();

          // Safely fallback handling string handles empty locations
          if (detectedCity.isEmpty) detectedCity = "Unknown City";
          if (detectedArea.isEmpty) detectedArea = "Unknown Area";

          // 1. Zones list update karein (agar nayi city hai to add ho jaye)
          List<String> updatedZones = List.from(state.availableZones);
          if (!updatedZones.contains(detectedCity)) {
            updatedZones.add(detectedCity);
          }

          // 2. Areas list update karein. Pehle static check karein, phir GPS area inject karein
          List<String> baseAreas = _repository.getStaticAreas(detectedCity);
          List<String> updatedAreas = List.from(baseAreas);
          if (!updatedAreas.contains(detectedArea)) {
            updatedAreas.add(detectedArea);
          }

          emit(state.copyWith(
            isLoading: false,
            availableZones: updatedZones,
            availableAreas: updatedAreas,
            selectedZone: ValueWrapper(detectedCity),
            selectedArea: ValueWrapper(detectedArea),
            isGpsSuccess: true,
          ));
        } else {
          throw Exception("Address not found");
        }
      } catch (e) {
        String msg = "Location fetch karne mein masla hua.";
        if (e.toString().contains('GPS_OFF')) msg = "Meharbani karke mobile ka GPS on karain.";
        if (e.toString().contains('PERMISSION_DENIED')) msg = "Location ki permission nahi mili.";

        emit(state.copyWith(
          isLoading: false,
          errorMessage: msg,
        ));
      }
    });
  }
}