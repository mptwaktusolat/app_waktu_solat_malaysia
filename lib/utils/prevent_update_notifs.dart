//If less than 3 days, since the last notif is scheduled, do not rescehdule
//3 days = 259200000 millis
//15 seconds = 15000
//4 hours = 14400000
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/utils/DateAndTime.dart';

class PreventUpdatingNotifs {
  /// setNow() function
  /// only check duration if in the same month
  /// if different month, schedule will take place no matter what
  /// If user set to force update notif, then notification will force to update
  static void setNow() {
    if (GetStorage().read(kForceUpdateNotif)) {
      //checks is force update,if true then notif should update,
      shouldUpdateNotification(GetStorage().read(kIsDebugMode));
    } else {
      if (DateAndTime.isTheSameMonth(
          GetStorage().read(kStoredLastUpdateNotif))) {
        //check if same month or mot, notification will update if not in the month
        if ((DateTime.now().millisecondsSinceEpoch -
                GetStorage().read(kStoredLastUpdateNotif)) <
            14400000) {
          //TODO: Change to 3 days
          //check if certain period o time has reached
          dontUpdateNotification(GetStorage().read(kIsDebugMode));
        } else {
          shouldUpdateNotification(GetStorage().read(kIsDebugMode));
        }
      } else {
        shouldUpdateNotification(GetStorage().read(kIsDebugMode));
      }
    }

    GetStorage().write(kForceUpdateNotif,
        false); // turn back to false because it should run only once
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
