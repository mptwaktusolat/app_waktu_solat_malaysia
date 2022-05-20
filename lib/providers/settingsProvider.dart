import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../CONSTANTS.dart';

class SettingProvider with ChangeNotifier {
  bool _use12hour = GetStorage().read(kStoredTimeIs12);
  bool _showOtherPrayerTime = GetStorage().read(kStoredShowOtherPrayerTime);
  bool _isDeveloperOption = GetStorage().read(kDiscoveredDeveloperOption);
  int _sharingFormat = GetStorage().read(kSharingFormat);
  double _fontSize = GetStorage().read(kFontSize);

  set prayerFontSize(double newValue) {
    _fontSize = newValue;
    GetStorage().write(kFontSize, newValue);
    notifyListeners();
  }

  double get prayerFontSize => _fontSize;

  set sharingFormat(int newValue) {
    _sharingFormat = newValue;
    GetStorage().write(kSharingFormat, newValue);
    notifyListeners();
  }

  int get sharingFormat => _sharingFormat;

  set use12hour(bool newValue) {
    _use12hour = newValue;
    GetStorage().write(kStoredTimeIs12, newValue);
    notifyListeners();
  }

  bool get use12hour => _use12hour;

  set showOtherPrayerTime(bool newValue) {
    _showOtherPrayerTime = newValue;
    GetStorage().write(kStoredShowOtherPrayerTime, newValue);
    notifyListeners();
  }

  bool get showOtherPrayerTime => _showOtherPrayerTime;

  set isDeveloperOption(bool newValue) {
    GetStorage().write(kDiscoveredDeveloperOption, newValue);
    _isDeveloperOption = newValue;
    notifyListeners();
  }

  bool get isDeveloperOption => _isDeveloperOption;
}
