//adapted from https://gist.github.com/RodBr/4d6ebfea8b1f9432ff088bec4455e15c#file-main4-dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/utils/prevent_update_notifs.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode themeMode) async {
    PreventUpdatingNotifs.setNow();
    Get.changeThemeMode(themeMode);
    _themeMode = themeMode;
    update();
    GetStorage().write('theme', themeMode.toString().split('.')[1]);
  }

  getThemeModeFromPreferences() async {
    ThemeMode themeMode;

    String themeText = GetStorage().read('theme') ??
        'light'; //by default, light is selected
        //TODO: Change to system in later release
    try {
      themeMode =
          ThemeMode.values.firstWhere((e) => describeEnum(e) == themeText);
    } catch (e) {
      themeMode = ThemeMode.system;
    }
    setThemeMode(themeMode);
  }
}
