import 'package:flutter/material.dart';

//Adaptation of https://gist.github.com/bimsina/4148f3ba1f69d8fbdfeae2d2c8e1a81c#file-utils-dart

final ThemeData kLightTheme = _buildLightTheme();

ThemeData _buildLightTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith();
}

final kDarkTheme = _buildDarkTheme();

ThemeData _buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base;
}

//amoled and others
