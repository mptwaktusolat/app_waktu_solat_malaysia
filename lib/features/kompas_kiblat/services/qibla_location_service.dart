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

abstract class QiblaLocationService {
  Future<bool> isLocationServiceEnabled();

  Future<LocationPermission> checkPermission();

  Future<LocationPermission> requestPermission();

  Future<QiblaCoordinates> getCurrentPosition();

  Future<QiblaPlace?> reverseGeocode(QiblaCoordinates coordinates);

  Future<bool> openLocationSettings();

  Future<bool> openAppSettings();
}

class GeolocatorQiblaLocationService implements QiblaLocationService {
  const GeolocatorQiblaLocationService();

  @override
  Future<LocationPermission> checkPermission() => Geolocator.checkPermission();

  @override
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

  @override
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
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

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();
}
