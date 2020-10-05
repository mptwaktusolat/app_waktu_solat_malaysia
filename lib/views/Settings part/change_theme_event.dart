//Adapted from https://gist.github.com/bimsina/1c3dea47cab04d55b2ed4d7da9f817dd#file-change_theme_event-dart

abstract class ChangeThemeEvent {}

class DecideTheme extends ChangeThemeEvent {}

class LightTheme extends ChangeThemeEvent {
  @override
  String toString() => 'LightTheme';
}

class DarkTheme extends ChangeThemeEvent {
  @override
  String toString() => 'DarkTheme';
}

class AmoledDarkTheme extends ChangeThemeEvent {
  @override
  String toString() => 'AmoledDarkTheme';
}
