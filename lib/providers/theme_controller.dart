//adapted from https://gist.github.com/RodBr/4d6ebfea8b1f9432ff088bec4455e15c#file-main4-dart

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../constants.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.values.byName(GetStorage().read(kAppTheme));

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    GetStorage().write(kAppTheme, mode.name);

    notifyListeners();
  }
}
