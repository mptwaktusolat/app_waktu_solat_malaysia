import 'package:geolocator/geolocator.dart';

class LocationData {
  static double latitude;
  static double longitude;

  static Future<void> getCurrentLocation() async {
    try {
      Position position =
          await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print('Error is $e');
    }
  }
}
