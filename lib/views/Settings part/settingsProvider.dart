import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../CONSTANTS.dart';

class SettingProvider with ChangeNotifier {
  bool _use12hour = GetStorage().read(kStoredTimeIs12);

  set use12hour(newValue) {
    _use12hour = newValue;
    notifyListeners();
  }

  bool get use12hour => _use12hour;
}
