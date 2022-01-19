//adapted from https://gist.github.com/RodBr/4d6ebfea8b1f9432ff088bec4455e15c#file-main4-dart

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../CONSTANTS.dart';
import '../../notificationUtil/prevent_update_notifs.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.values.byName(GetStorage().read(kAppTheme));

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    PreventUpdatingNotifs.setNow();
    _themeMode = themeMode;
    GetStorage().write(GetStorage().read(kAppTheme), themeMode.name);
    notifyListeners();
  }
}
