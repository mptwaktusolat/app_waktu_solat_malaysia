import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../CONSTANTS.dart';

class LocationProvider with ChangeNotifier {
  int? _currentLocationIndex = GetStorage().read(kStoredGlobalIndex);

  set currentLocationIndex(int? value) {
    _currentLocationIndex = value;
    GetStorage().write(kStoredGlobalIndex, value);
    notifyListeners();
  }

  int? get currentLocationIndex => _currentLocationIndex;
}
