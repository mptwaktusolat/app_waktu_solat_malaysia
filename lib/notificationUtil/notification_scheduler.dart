import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' hide LocationDatabase;
import '../models/jakim_esolat_model.dart';
import '../views/Settings%20part/NotificationSettingPage.dart';
import '../utils/debug_toast.dart';
import '../CONSTANTS.dart';
import '../locationUtil/locationDatabase.dart';
import 'notifications_helper.dart';

class MyNotifScheduler {
  static void schedulePrayNotification(List<PrayerTime> times) async {
    await FlutterLocalNotificationsPlugin().cancelAll(); //reset all
    var _currentDateTime = DateTime.now();

    String currentDaerah =
        LocationDatabase.daerah(GetStorage().read(kStoredLocationJakimCode));

    //if true, notification is scheduled by at most 7 days
    if (GetStorage().read(kStoredNotificationLimit)) {
      times = times.take(7).toList();
    }
    // for debug dialog
    GetStorage().write(kNumberOfNotifsScheduled, times.length);

    MyNotificationType _notifType =
        MyNotificationType.values[GetStorage().read(kNotificationType)];

    switch (_notifType) {
      case MyNotificationType.noazan:
        DebugToast.show('Notification: Default sound');
        _defaultScheduler(times, _currentDateTime, currentDaerah);
        break;
      case MyNotificationType.azan:
        DebugToast.show('Notification: Azan');
        _azanScheduler(times, _currentDateTime, currentDaerah);
        break;
    }

    scheduleAlertNotification(
      id: 2190,
      title: 'Monthly refresh reminder',
      body:
          'To continue receive prayer notification, open app at least once every month.',
      payload: kPayloadMonthly,
      // if month (12 + 1) = 13, it will auto-increment to next year
      //2021-01-01 00:05:00.000+0800
      scheduledTime: TZDateTime.local(
          _currentDateTime.year, _currentDateTime.month + 1, 1, 0, 5),
    );

    //This timestamp is later used to determine wether notification should be updated or not
    GetStorage()
        .write(kStoredLastUpdateNotif, DateTime.now().millisecondsSinceEpoch);
  }

  /// Classic Notification Scheduler, default notification sound
  static void _defaultScheduler(List<PrayerTime> times,
      DateTime currentDateTime, String currentLocation) async {
    for (var dayTime in times) {
      DateTime subuhDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![1]);
      DateTime syurukDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![2]);
      DateTime zuhrDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![4]);
      DateTime asarDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![5]);
      DateTime maghribDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![6]);
      DateTime isyakDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![7]);

      if (subuhDateTime.isAfter(currentDateTime)) {
        //to make sure the time is in future
        await scheduleSinglePrayerNotification(
          name: 'Fajr',
          id: int.parse(
              subuhDateTime.millisecondsSinceEpoch.toString().substring(5)),
          title: 'It\'s Subuh',
          scheduledTime: TZDateTime.from(subuhDateTime, local),
          body: 'in ' + currentLocation,
        );
      }
      if (syurukDateTime.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Syuruk',
          id: int.parse(
              syurukDateTime.millisecondsSinceEpoch.toString().substring(5)),
          title: 'It\'s Syuruk',
          body: 'in ' + currentLocation,
          summary: 'Ends of Subuh',
          scheduledTime: TZDateTime.from(syurukDateTime, local),
        );
      }
      if (zuhrDateTime.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Zuhr',
          id: int.parse(
              zuhrDateTime.millisecondsSinceEpoch.toString().substring(5)),
          title: 'It\'s Zohor',
          body: 'in ' + currentLocation,
          summary:
              zuhrDateTime.weekday == DateTime.friday ? 'Salam Jumaat' : null,
          scheduledTime: TZDateTime.from(zuhrDateTime, local),
        );
      }
      if (asarDateTime.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Asr',
          id: int.parse(
              asarDateTime.millisecondsSinceEpoch.toString().substring(5)),
          title: 'It\'s Asar',
          body: 'in ' + currentLocation,
          scheduledTime: TZDateTime.from(asarDateTime, local),
        );
      }
      if (maghribDateTime.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Maghrib',
          id: int.parse(
              maghribDateTime.millisecondsSinceEpoch.toString().substring(5)),
          title: 'It\'s Maghrib',
          body: 'in ' + currentLocation,
          scheduledTime: TZDateTime.from(maghribDateTime, local),
        );
      }
      if (isyakDateTime.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Isya\'',
          id: int.parse(
              isyakDateTime.millisecondsSinceEpoch.toString().substring(5)),
          title: 'It\'s Isyak',
          body: 'in ' + currentLocation,
          scheduledTime: TZDateTime.from(isyakDateTime, local),
        );
      }
    }
  }

  /// Notification but with azan
  static void _azanScheduler(List<PrayerTime> times, DateTime currentDateTime,
      String currentLocation) async {
    for (var dayTime in times) {
      DateTime subuhDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![1]);
      DateTime syurukDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![2]);
      DateTime zuhrDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![4]);
      DateTime asarDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![5]);
      DateTime maghribDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![6]);
      DateTime isyakDateTime =
          DateTime.fromMillisecondsSinceEpoch(dayTime.times![7]);

      if (subuhDateTime.isAfter(currentDateTime)) {
        //to make sure the time is in future
        await scheduleSingleAzanNotification(
            name: 'Fajr',
            id: int.parse(
                subuhDateTime.millisecondsSinceEpoch.toString().substring(5)),
            title: 'It\'s Subuh',
            scheduledTime: TZDateTime.from(subuhDateTime, local),
            body: 'in ' + currentLocation,
            customSound: 'azan_hejaz2013_fajr');
      }
      if (syurukDateTime.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Syuruk',
          id: int.parse(
              syurukDateTime.millisecondsSinceEpoch.toString().substring(5)),
          title: 'It\'s Syuruk',
          body: 'in ' + currentLocation,
          summary: 'Ends of Subuh',
          scheduledTime: TZDateTime.from(syurukDateTime, local),
        );
      }
      if (zuhrDateTime.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
            name: 'Zuhr',
            id: int.parse(
                zuhrDateTime.millisecondsSinceEpoch.toString().substring(5)),
            title: 'It\'s Zohor',
            body: 'in ' + currentLocation,
            summary:
                zuhrDateTime.weekday == DateTime.friday ? 'Salam Jumaat' : null,
            scheduledTime: TZDateTime.from(zuhrDateTime, local),
            customSound: 'azan_kurdhi2010');
      }
      if (asarDateTime.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
            name: 'Asr',
            id: int.parse(
                asarDateTime.millisecondsSinceEpoch.toString().substring(5)),
            title: 'It\'s Asar',
            body: 'in ' + currentLocation,
            scheduledTime: TZDateTime.from(asarDateTime, local),
            customSound: 'azan_kurdhi2010');
      }
      if (maghribDateTime.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
            name: 'Maghrib',
            id: int.parse(
                maghribDateTime.millisecondsSinceEpoch.toString().substring(5)),
            title: 'It\'s Maghrib',
            body: 'in ' + currentLocation,
            scheduledTime: TZDateTime.from(maghribDateTime, local),
            customSound: 'azan_kurdhi2010');
      }
      if (isyakDateTime.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
            name: 'Isya\'',
            id: int.parse(
                isyakDateTime.millisecondsSinceEpoch.toString().substring(5)),
            title: 'It\'s Isyak',
            body: 'in ' + currentLocation,
            scheduledTime: TZDateTime.from(isyakDateTime, local),
            customSound: 'azan_kurdhi2010');
      }
    }
  }
}
