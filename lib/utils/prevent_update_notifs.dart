//If less than 3 days, since the last notif is scheduled, do not rescehdule
//3 days = 259200000 millis
//15 seconds = 15000
//4 hours = 14400000
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/utils/DateAndTime.dart';

bool isDebug = GetStorage().read(kIsDebugMode);

class PreventUpdatingNotifs {
  /// setNow() function
  /// only check duration if in the same month
  /// if different month, schedule will take place no matter what
  static void setNow() {
    if (DateAndTime.isTheSameMonth(GetStorage().read(kStoredLastUpdateNotif))) {
      if ((DateTime.now().millisecondsSinceEpoch -
              GetStorage().read(kStoredLastUpdateNotif)) <
          14400000) {
        dontUpdateNotification(isDebug);
      } else {
        shouldUpdateNotification(isDebug);
      }
    } else {
      shouldUpdateNotification(isDebug);
    }
  }
}

void shouldUpdateNotification(bool isDebug) {
  GetStorage().write(kStoredShouldUpdateNotif, true);
  print('Notification should update');
  if (isDebug) {
    Fluttertoast.showToast(msg: 'Notification should update');
  }
}

void dontUpdateNotification(bool isDebug) {
  print('Notification should not update');
  if (isDebug) {
    Fluttertoast.showToast(msg: 'Notification should not update');
  }
  GetStorage().write(kStoredShouldUpdateNotif, false);
}
