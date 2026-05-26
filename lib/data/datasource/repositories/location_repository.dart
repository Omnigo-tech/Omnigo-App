// lib/data/repositories/location_repository.dart
import '../services/location_service.dart';

class LocationRepository {
  final LocationService _locationService;

  LocationRepository(this._locationService);

  // GPS se location data lena
  Future<Map<String, String>?> fetchGpsLocation() async {
    return await _locationService.getUserCurrentAddress();
  }

  // Hardcoded Zones ki list (Kal ko aap yahan Backend API integration kar sakte hain)
  List<String> getStaticZones() {
    return ["Rawalpindi", "Islamabad"];
  }

  // Zone ki base par Areas ki list
  List<String> getStaticAreas(String zone) {
    if (zone == "Islamabad") {
      return ["G-11", "F-6", "I-8"];
    } else if (zone == "Rawalpindi") {
      return ["Saddar", "6th Road", "Commercial Market"];
    }
    return [];
  }
}