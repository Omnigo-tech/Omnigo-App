import '../../../core/network/api_service.dart';
import '../local/auth_local_data_source.dart';
import '../services/location_service.dart';
import '../../models/zone_model.dart'; // Model ka sahi path dein

class LocationRepository {
  final LocationService _locationService;
  final ApiService _apiService;
  final AuthLocalDataSource _localDataSource;
  List<ZoneModel> _cachedZones = [];

  LocationRepository(
    this._locationService,
    this._apiService,
    this._localDataSource,
  );
  // GPS se location data lena (Pehle se majood)
  Future<Map<String, dynamic>?> fetchGpsLocation() async {
    return await _locationService.getUserCurrentAddress();
  }

  // API se data fetch karne ka main function
  Future<List<ZoneModel>> fetchZonesFromApi() async {
    try {
      final response = await _apiService.getZones();
      if (response['success'] == true && response['zones'] != null) {
        final List<dynamic> zonesJson = response['zones'];
        _cachedZones = zonesJson
            .map((json) => ZoneModel.fromJson(json))
            .toList();
        return _cachedZones;
      }
      return [];
    } catch (e) {
      print("Error fetching zones from API: $e");
      return [];
    }
  }

  // Cache se sirf zone ke names ki list nikalna
  List<String> getZoneNamesFromCache() {
    return _cachedZones.map((z) => z.zoneName).toList();
  }

  // Selected Zone ke areas cache se filter karna (No Extra Network Call)
  List<String> getAreasByZoneFromCache(String zoneName) {
    final matchedZone = _cachedZones.firstWhere(
      (z) => z.zoneName.toLowerCase() == zoneName.toLowerCase(),
      orElse: () => ZoneModel(id: '', zoneName: '', areas: [], isActive: false),
    );
    return matchedZone.areas;
  }

  Future<dynamic> saveManualLocation({
    required String zone,
    required String area,
    required String address,
  }) async {
    final userId = _localDataSource.getUserId();

    final response = await _apiService.saveManualLocation({
      "userId": userId,
      "zone": zone,
      "area": area,
      "address": address,
    });

    if (response != null &&
        (response['success'] == true || response['status'] == 200)) {
      await _localDataSource.saveUserLocation({
        "zone": zone,
        "area": area,
        "address": address,
        "isEnabled": true,
        "coordinates": {"lat": null, "lng": null},
      });
    }

    return response;
  }

  Future<dynamic> saveAutoLocation({
    required String zone,
    required String area,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final userId = _localDataSource.getUserId();

    final response = await _apiService.saveAutoLocation({
      "userId": userId,
      "zone": zone,
      "area": area,
      "address": address,
      "lat": lat,
      "lng": lng,
    });

    if (response != null &&
        (response['success'] == true || response['status'] == 200)) {
      await _localDataSource.saveUserLocation({
        "zone": zone,
        "area": area,
        "address": address,
        "isEnabled": true,
        "coordinates": {"lat": lat, "lng": lng},
      });
    }

    return response;
  }
}
