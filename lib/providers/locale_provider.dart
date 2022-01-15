import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';

class LocaleProvider with ChangeNotifier {
  String _appLocale = GetStorage().read(kAppLanguage);

  set appLocale(String value) {
    _appLocale = value;
    GetStorage().write(kAppLanguage, value);

    notifyListeners();
  }

  String get appLocale => _appLocale;
}
