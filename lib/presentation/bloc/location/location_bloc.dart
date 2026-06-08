import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _repository;

  LocationBloc(this._repository) : super(LocationState()) {

    // 1. Initial Load (Fetch available zones from API)
    on<LoadInitialDataEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      await _repository.fetchZonesFromApi();
      final zones = _repository.getZoneNamesFromCache();

      emit(state.copyWith(
        isLoading: false,
        availableZones: zones,
      ));
    });

    // 2. Manual Zone Change (Clears error and resets area)
    on<ChangeZoneEvent>((event, emit) {
      final areas = _repository.getAreasByZoneFromCache(event.selectedZone);
      emit(state.copyWith(
        selectedZone: ValueWrapper(event.selectedZone),
        availableAreas: areas,
        selectedArea:  ValueWrapper(null),     // Reset sub-area safely
        detectedAddress:  ValueWrapper(null),  // Reset manual type on zone change
        errorMessage:  ValueWrapper(null),     // ✨ Clear error so snackbar disappears
        successMessage:  ValueWrapper(null),
      ));
    });

    // 3. Manual Area Change (Clears error)
    on<ChangeAreaEvent>((event, emit) {
      emit(state.copyWith(
        selectedArea: ValueWrapper(event.selectedArea),
        errorMessage:  ValueWrapper(null),     // ✨ Clear error on area change
        successMessage:  ValueWrapper(null),
      ));
    });

    // 4. Manual Location Submit Action
    on<SubmitManualLocationEvent>((event, emit) async {
      emit(state.copyWith(
          isLoading: true,
          errorMessage:  ValueWrapper(null),
          successMessage:  ValueWrapper(null)
      ));

      try {
        final response = await _repository.saveManualLocation(
          zone: event.zone,
          area: event.area,
          address: event.address,
        );

        String msg = response['message'] ?? "Location saved successfully";

        emit(state.copyWith(
          isLoading: false,
          successMessage: ValueWrapper(msg),
        ));
      } catch (e) {
        String msg = "Failed to save location. Please try again.";
        final errorStr = e.toString();

        if (errorStr.contains('bad response') || errorStr.contains('400') || errorStr.contains('Not serviceable')) {
          msg = "Omnigo is not available in this area yet. Please select another location.";
        } else {
          msg = errorStr.replaceAll("Exception:", "").replaceAll("ServerException:", "").trim();
        }

        emit(state.copyWith(
          isLoading: false,
          errorMessage: ValueWrapper(msg),
        ));
      }
    });

    on<FetchGpsLocationEvent>((event, emit) async {
      emit(state.copyWith(
        isLoading: true,
        errorMessage:  ValueWrapper(null),
        successMessage:  ValueWrapper(null),
      ));

      try {
        final addressData = await _repository.fetchGpsLocation();

        if (addressData != null) {
          String detectedCity = (addressData['city'] as String).trim();
          String detectedArea = (addressData['area'] as String).trim();
          String fullAddress = (addressData['address'] as String?)?.trim() ?? "";
          double latitude = addressData['lat'] as double;
          double longitude = addressData['lng'] as double;

          if (detectedCity.isEmpty) detectedCity = "Unknown City";
          if (detectedArea.isEmpty) detectedArea = "Unknown Area";

          List<String> updatedZones = List.from(state.availableZones);
          if (!updatedZones.contains(detectedCity)) updatedZones.add(detectedCity);

          List<String> baseAreas = _repository.getAreasByZoneFromCache(detectedCity);
          List<String> updatedAreas = List.from(baseAreas);
          if (!updatedAreas.contains(detectedArea)) updatedAreas.add(detectedArea);

          final response = await _repository.saveAutoLocation(
            zone: detectedCity,
            area: detectedArea,
            address: fullAddress,
            lat: latitude,
            lng: longitude,
          );

          String successMsg = response['message'] ?? "Location updated successfully.";

          emit(state.copyWith(
            isLoading: false,
            availableZones: updatedZones,
            availableAreas: updatedAreas,
            selectedZone: ValueWrapper(detectedCity),
            selectedArea: ValueWrapper(detectedArea),
            detectedAddress: ValueWrapper(fullAddress),
            successMessage: ValueWrapper(successMsg),
            isGpsSuccess: true,
          ));
        } else {
          throw Exception("ADDRESS_NOT_FOUND");
        }
      } catch (e) {
        String msg = "Failed to fetch location. Please try again.";
        final errorStr = e.toString();

        // Server validation mapping for status code 400
        if (errorStr.contains('bad response') || errorStr.contains('400') || errorStr.contains('Not serviceable')) {
          msg = "Omnigo is not available in this area yet. Please select your location manually.";
        }
        else if (errorStr.contains('ServerException') || errorStr.contains('Exception:')) {
          String extractedMsg = errorStr.split(':').last.trim();
          if (extractedMsg.isNotEmpty) msg = extractedMsg;

          if (msg.toLowerCase() == "not serviceable") {
            msg = "Omnigo is not available in this area yet. Please select your location manually.";
          }
        }
        // Hardware system responses
        else if (errorStr.contains('GPS_OFF')) {
          msg = "GPS is off. Please turn on location services.";
        }
        else if (errorStr.contains('PERMISSION_DENIED')) {
          msg = "Location permission denied.";
        }
        else if (errorStr.contains('PERMISSION_PERMANENTLY_DENIED')) {
          msg = "Permission blocked. Enable it from App Settings.";
        }
        else if (errorStr.contains('ADDRESS_NOT_FOUND')) {
          msg = "Address not found. Please select manually.";
        }
        else if (errorStr.contains('TimeoutException')) {
          msg = "Connection timed out. Please try again.";
        }

        emit(state.copyWith(
          isLoading: false,
          errorMessage: ValueWrapper(msg),
        ));
      }
    });
  }
}