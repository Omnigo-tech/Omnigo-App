// lib/data/services/location_service.dart
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Map<String, dynamic>?> getUserCurrentAddress() async { // Map<String, String> ko dynamic banaya
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('GPS_OFF');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw Exception('PERMISSION_DENIED');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('PERMISSION_PERMANENTLY_DENIED');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      String fullAddress = [
        if (place.street != null && place.street!.isNotEmpty) place.street,
        if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality,
        if (place.locality != null && place.locality!.isNotEmpty) place.locality,
      ].join(', ');

      return {
        "city": place.locality ?? "",
        "area": place.subLocality ?? place.name ?? "",
        "address": fullAddress,
        "lat": position.latitude,  // ✨ Lat yahan se bhej di
        "lng": position.longitude, // ✨ Lng bhi yahan se bhej di
      };
    }
    return null;
  }
}