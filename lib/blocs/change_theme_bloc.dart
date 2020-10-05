//adapted from https://gist.github.com/bimsina/16a59876046bcc4b0c41d3c5f18522fa#file-change_theme_bloc-dart

import 'package:bloc/bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/change_theme_event.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/change_theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeThemeBloc extends Bloc<ChangeThemeEvent, ChangeThemeState> {
  // ChangeThemeBloc(ChangeThemeState initialState) : super(initialState);

  void onLightThemeChange() => add(LightTheme());
  void onDarkThemeChange() => add(DarkTheme());
  void onAmoledThemeChange() => add(AmoledDarkTheme());
  void onDecideThemeChange() => add(DecideTheme());

  @override
  ChangeThemeState get initialState => ChangeThemeState.lightTheme();

  @override
  Stream<ChangeThemeState> mapEventToState(ChangeThemeEvent event) async* {
    if (event is DecideTheme) {
      final int optionValue = await getOption();
      if (optionValue == 0) {
        yield ChangeThemeState.lightTheme();
      } else if (optionValue == 1) {
        yield ChangeThemeState.darkTheme();
      }
      // else if (optionValue == 2) {
      //   yield ChangeThemeState.amoledTheme();
      // }
    }
    if (event is LightTheme) {
      yield ChangeThemeState.lightTheme();
      try {
        _saveOptionValue(0);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }

    if (event is DarkTheme) {
      yield ChangeThemeState.darkTheme();
      try {
        _saveOptionValue(1);
      } catch (_) {
        throw Exception("Could not persist change");
      }
    }

    // if (event is AmoledTheme) {
    //   yield ChangeThemeState.amoledTheme();
    //   try {
    //     _saveOptionValue(2);
    //   } catch (_) {
    //     throw Exception("Could not persist change");
    //   }
    // }
  }

  Future<Null> _saveOptionValue(int optionValue) async {
    GetStorage().write('theme_option', optionValue);
  }

  Future<int> getOption() async {
    int option = GetStorage().read('theme_option') ?? 0;
    return option;
  }
}

final ChangeThemeBloc changeThemeBloc = ChangeThemeBloc()
  ..onDecideThemeChange();
