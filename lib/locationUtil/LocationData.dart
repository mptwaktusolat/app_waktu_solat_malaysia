import 'package:geolocator/geolocator.dart';

class LocationData {
  static Position _position;

  static Future<Position> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy:
              LocationAccuracy.low); //on Android, low is in 500m radius
      _position = position;
      print('[LocationData] Sucess getting $position');
      return position;
    } catch (e) {
      print('[LocationData] Error is $e');
      throw 'Error occured: $e';
    }
  }

  static get position => _position;
}
