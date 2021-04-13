import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../CONSTANTS.dart';

class SettingProvider with ChangeNotifier {
  bool _use12hour = GetStorage().read(kStoredTimeIs12);
  bool _showOtherPrayerTime = GetStorage().read(kStoredShowOtherPrayerTime);
  bool _isDeveloperOption = GetStorage().read(kDiscoveredDeveloperOption);
  int _sharingFormat = GetStorage().read(kSharingFormat);
  double _fontSize = GetStorage().read(kFontSize);
  int _hijriOffset = GetStorage().read(kHijriOffset);

  set hijriOffset(int value) {
    _hijriOffset = value;
    GetStorage().write(kHijriOffset, value);
    notifyListeners();
  }

  int get hijriOffset => _hijriOffset;

  set prayerFontSize(double newValue) {
    _fontSize = newValue;
    GetStorage().write(kFontSize, newValue);
    notifyListeners();
  }

  double get prayerFontSize => _fontSize;

  set sharingFormat(newValue) {
    _sharingFormat = newValue;
    GetStorage().write(kSharingFormat, newValue);
    notifyListeners();
  }

  int get sharingFormat => _sharingFormat;

  set use12hour(newValue) {
    _use12hour = newValue;
    notifyListeners();
  }

  bool get use12hour => _use12hour;

  set showOtherPrayerTime(newValue) {
    _showOtherPrayerTime = newValue;
    notifyListeners();
  }

  bool get showOtherPrayerTime => _showOtherPrayerTime;

  set isDeveloperOption(newValue) {
    _isDeveloperOption = newValue;
    notifyListeners();
  }

  bool get isDeveloperOption => _isDeveloperOption;
}
