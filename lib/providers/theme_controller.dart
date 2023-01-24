//adapted from https://gist.github.com/RodBr/4d6ebfea8b1f9432ff088bec4455e15c#file-main4-dart

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

import '../CONSTANTS.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.values.byName(GetStorage().read(kAppTheme));

  ThemeProvider() {
    // Setup correct status bar during startup
    _changeSystemUI();
  }

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    GetStorage().write(kAppTheme, mode.name);
    _changeSystemUI();

    notifyListeners();
  }

  /// Change system navigation colour
  void _changeSystemUI() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDeviceDarkMode = brightness == Brightness.dark;

    if (_themeMode == ThemeMode.system
        ? isDeviceDarkMode
        : _themeMode == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Color(0xff14544e)));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.teal.shade50));
    }
  }
}
