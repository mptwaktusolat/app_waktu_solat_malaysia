import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../CONSTANTS.dart';

class LocationProvider with ChangeNotifier {
  String _currentLocationCode = GetStorage().read(kStoredLocationJakimCode);

  set currentLocationCode(String value) {
    _currentLocationCode = value;
    GetStorage().write(kStoredLocationJakimCode, value);
    notifyListeners();
  }

  String get currentLocationCode => _currentLocationCode;
}
