//If less than 2 days, since the last notif is scheduled, do not rescehdule

import 'package:get_storage/get_storage.dart';

import '../shared/constants/constants.dart';
import '../shared/utils/date_time_utils.dart';
import '../shared/utils/debug_toast.dart';

/// In [PrayTimeList] widget, we call update notification everytime the widget
/// rebuild (i.e. user change zone, etc.).
/// This function is to prevent the notification from being rescheduled too often
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
    if (!DateTimeUtil.isSameMonthFromMillis(
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
