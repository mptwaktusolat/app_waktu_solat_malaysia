import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

import '../constants.dart';

class DebugToast {
  static void show(String? mesage,
      {bool force = false, Toast duration = Toast.LENGTH_SHORT}) {
    if (force || GetStorage().read(kIsDebugMode)) {
      Fluttertoast.showToast(msg: mesage!, toastLength: duration);
    }
  }
}
