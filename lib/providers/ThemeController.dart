//adapted from https://gist.github.com/RodBr/4d6ebfea8b1f9432ff088bec4455e15c#file-main4-dart

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../notificationUtil/prevent_update_notifs.dart';

class ThemeController with ChangeNotifier {
  ThemeMode? _themeMode;
  ThemeMode? get themeMode => _themeMode;

  set themeMode(ThemeMode? themeMode) {
    PreventUpdatingNotifs.setNow();
    _themeMode = themeMode;
    GetStorage().write('theme', themeMode.toString().split('.').last);
    notifyListeners();
  }

  ThemeController() {
    String themeText =
        GetStorage().read('theme') ?? 'light'; //by default, light is selected
    try {
      _themeMode = ThemeMode.values.byName(themeText);
    } catch (e) {
      _themeMode = ThemeMode.system;
    }
  }
}
