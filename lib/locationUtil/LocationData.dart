import 'package:geolocator/geolocator.dart';

class LocationData {
  static Position? _position;

  static Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy:
            LocationAccuracy.low); //on Android, low is in 500m radius
    _position = position;
    return position;
  }

  static Position? get position => _position;
}
