import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../constants.dart';
import '../views/settings/full_prayer_table_settings.dart';

class TimetableProvider extends ChangeNotifier {
  bool _showHijri = GetStorage().read(kTimetableHijri) ?? true;
  // default to short style
  HijriStyle _hijriStyle = HijriStyle.values
      .byName(GetStorage().read(kTimetableHijriStyle) ?? HijriStyle.short.name);

  bool _showLastOneThirdNight =
      GetStorage().read(kTimetableShowOneThird) ?? false;

  bool get showHijri => _showHijri;

  set showHijri(bool value) {
    _showHijri = value;
    GetStorage().write(kTimetableHijri, value);
    notifyListeners();
  }

  HijriStyle get hijriStyle => _hijriStyle;

  set hijriStyle(HijriStyle value) {
    _hijriStyle = value;
    GetStorage().write(kTimetableHijriStyle, value.name);
    notifyListeners();
  }

  bool get showLastOneThirdNight => _showLastOneThirdNight;

  set showLastOneThirdNight(bool newValue) {
    _showLastOneThirdNight = newValue;
    GetStorage().write(kTimetableShowOneThird, newValue);
    notifyListeners();
  }
}
