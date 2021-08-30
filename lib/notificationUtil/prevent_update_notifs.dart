//If less than 2 days, since the last notif is scheduled, do not rescehdule

import 'package:get_storage/get_storage.dart';
import '../utils/debug_toast.dart';
import '../CONSTANTS.dart';
import '../utils/DateAndTime.dart';

class PreventUpdatingNotifs {
  /// setNow() function
  /// only check duration if in the same month
  /// if different month, schedule will take place no matter what
  /// If user set to force update notif, then notification will force to update
  static void setNow() {
    if (GetStorage().read(kForceUpdateNotif)) {
      //checks is force update,if true then notif should update,
      shouldUpdateNotification();
    } else {
      if (DateAndTime.isSameMonthFromMillis(
          GetStorage().read(kStoredLastUpdateNotif))) {
        //check if same month or mot, notification will update if not in the month
        if ((DateTime.now().millisecondsSinceEpoch -
                GetStorage().read(kStoredLastUpdateNotif)) <
            const Duration(days: 2).inMilliseconds) {
          //check if certain period o time has reached
          dontUpdateNotification();
        } else {
          shouldUpdateNotification();
        }
      } else {
        shouldUpdateNotification();
      }
    }

    GetStorage().write(kForceUpdateNotif,
        false); // turn back to false because it should run only once
  }
}

void shouldUpdateNotification() {
  GetStorage().write(kStoredShouldUpdateNotif, true);
  DebugToast.show('Notification should update');
}

void dontUpdateNotification() {
  DebugToast.show('Notification should not update');
  GetStorage().write(kStoredShouldUpdateNotif, false);
}
