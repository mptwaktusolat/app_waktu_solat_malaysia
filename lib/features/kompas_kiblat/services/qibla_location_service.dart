import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class QiblaCoordinates {
  const QiblaCoordinates({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class QiblaPlace {
  const QiblaPlace({
    this.subLocality,
    this.locality,
    this.subAdministrativeArea,
    this.administrativeArea,
    this.country,
    this.isoCountryCode,
  });

  final String? subLocality;
  final String? locality;
  final String? subAdministrativeArea;
  final String? administrativeArea;
  final String? country;
  final String? isoCountryCode;
}

class QiblaLocationService {
  const QiblaLocationService();

  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  Future<QiblaCoordinates> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    return QiblaCoordinates(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  Future<QiblaPlace?> reverseGeocode(QiblaCoordinates coordinates) async {
    final placemarks = await placemarkFromCoordinates(
      coordinates.latitude,
      coordinates.longitude,
    );
    if (placemarks.isEmpty) return null;

    final placemark = placemarks.first;
    return QiblaPlace(
      subLocality: placemark.subLocality,
      locality: placemark.locality,
      subAdministrativeArea: placemark.subAdministrativeArea,
      administrativeArea: placemark.administrativeArea,
      country: placemark.country,
      isoCountryCode: placemark.isoCountryCode,
    );
  }

  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();
}
