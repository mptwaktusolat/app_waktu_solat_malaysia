//Adapted from https://gist.github.com/bimsina/b302ff5856c4310d7d152b3fc5177f55#file-change_theme_state-dart

import 'package:flutter/material.dart';
import 'package:waktusolatmalaysia/utils/themeUtils.dart';

class ChangeThemeState {
  final ThemeData themeData;

  ChangeThemeState({@required this.themeData});

  factory ChangeThemeState.lightTheme() {
    return ChangeThemeState(themeData: kLightTheme);
  }

  factory ChangeThemeState.darkTheme() {
    return ChangeThemeState(themeData: kDarkTheme);
  }

  // factory ChangeThemeState.amoledTheme() {
  //   return ChangeThemeState(themeData: kAmoledTheme);
  // }
}
