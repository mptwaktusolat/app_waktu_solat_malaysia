//If less than 2 days, since the last notif is scheduled, do not rescehdule

import 'package:get_storage/get_storage.dart';
import '../constants.dart';
import '../utils/date_and_time.dart';
import '../utils/debug_toast.dart';

class PreventUpdatingNotifs {
  static bool shouldUpdate() {
    // forece update if user change location, or through the setting page
    if (GetStorage().read(kShouldUpdateNotif)) {
      // turn back to false because it should run only once
      GetStorage().write(kShouldUpdateNotif, false);
      // return true to update notif
      return true;
    }

    //notification will update if not in the same month
    if (!DateAndTime.isSameMonthFromMillis(
        GetStorage().read(kStoredLastUpdateNotif))) {
      return true;
    }

    //notification will get rescheduled after certain period
    if ((DateTime.now().millisecondsSinceEpoch -
            GetStorage().read(kStoredLastUpdateNotif)) >
        const Duration(days: 2).inMilliseconds) {
      return true;
    }

    DebugToast.show("All condition false, will not scheduling notification");
    return false;
  }
}
