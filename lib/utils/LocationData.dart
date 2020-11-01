import 'package:geolocator/geolocator.dart';

class LocationData {
  static double latitude;
  static double longitude;

  static Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy:
              LocationAccuracy.low); //on Android, low is in 500m radius
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print('Error is $e');
    }
  }
}
