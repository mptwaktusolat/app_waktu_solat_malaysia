import 'package:geolocator/geolocator.dart';

class LocationData {
  static double latitude;
  static double longitude;

  static Future<Position> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy:
              LocationAccuracy.low); //on Android, low is in 500m radius
      latitude = position.latitude;
      longitude = position.longitude;
      print('[LocationData] Sucess getting $position');
      return position;
    } catch (e) {
      print('[LocationData] Error is $e');
      throw 'Error occured: $e';
    }
  }
}
