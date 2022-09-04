import 'package:flutter/material.dart';

class AutostartWarningProvider extends ChangeNotifier {
  bool _hasClickOpen = false;

  bool get hasClick => _hasClickOpen;

  set hasClick(bool hasClickOpen) {
    _hasClickOpen = hasClickOpen;
    notifyListeners();
  }
}
