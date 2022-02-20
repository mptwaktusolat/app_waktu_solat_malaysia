import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import '../CONSTANTS.dart';

class TimetableProvider extends ChangeNotifier {
  bool _showHijri = GetStorage().read(kTimetableHijri) ?? true;

  bool get showHijri => _showHijri;

  set showHijri(bool value) {
    _showHijri = value;
    GetStorage().write(kTimetableHijri, value);
    notifyListeners();
  }
}
