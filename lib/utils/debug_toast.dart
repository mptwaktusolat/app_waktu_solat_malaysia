import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';

class DebugToast {
  static final _isDebugToastOn = GetStorage().read(kIsDebugMode);
  static void show(String mesage, {bool force = false}) {
    if (force || _isDebugToastOn) Fluttertoast.showToast(msg: mesage);
  }
}
