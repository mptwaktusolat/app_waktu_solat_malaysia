import 'package:geolocator/geolocator.dart';

class LocationData {
  static Position? _position;

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // [LocationAccuracy.medium] corresponds to PRIORITY_BALANCED_POWER_ACCURACY in Android
    // Where it is a tradeoff that is balanced between location accuracy and power usage.
    // source: https://github.com/Baseflow/flutter-geolocator/issues/1082#issuecomment-1160056175
    // source: https://developers.google.com/android/reference/com/google/android/gms/location/Priority#PRIORITY_BALANCED_POWER_ACCURACY
    // However in this settings, Android emulator will not get use the location that have been
    // set in the emulator settings. So, there might be an issue when testing the app
    // in the emulator. By changing LocationAccuracy.high may solve the problem.
    // I'll stay with medium because I think we don't need that high accuracy for this app.
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    _position = position;
    return position;
  }

  static Position? get position => _position;
}
