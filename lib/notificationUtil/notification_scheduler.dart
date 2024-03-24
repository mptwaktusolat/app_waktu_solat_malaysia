import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' hide LocationDatabase;

import '../constants.dart';
import '../location_utils/location_database.dart';
import '../models/mpt_server_solat.dart';
import '../utils/debug_toast.dart';
import '../views/settings/notification_page_setting.dart';
import 'notifications_helper.dart';

class MyNotifScheduler {
  /// Check if app can schedule notification on Android 13+ (S+). Always return true on Android 12 and below.
  static Future<bool> _canScheduleNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final androidNotif =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    // underlying implementation: https://github.com/MaikuB/flutter_local_notifications/blob/ca71c96ba2a245175b44471e2e41e4958d480876/flutter_local_notifications/android/src/main/java/com/dexterous/flutterlocalnotifications/FlutterLocalNotificationsPlugin.java#L2119
    final res = await androidNotif?.canScheduleExactNotifications();
    return res ?? false;
  }

  /// Schedule notification for each prayer time.
  static void schedulePrayNotification(
      AppLocalizations appLocalizationsInstance, List<Prayers> times) async {
    if (!await _canScheduleNotification()) {
      print(
          'Notifications are not scheduled. Schedule notification permission is not granted huhu');
      return;
    }
    await FlutterLocalNotificationsPlugin().cancelAll(); //reset all
    final currentDateTime = DateTime.now();

    final String currentDaerah =
        LocationDatabase.daerah(GetStorage().read(kStoredLocationJakimCode));

    //if true, notification is scheduled by at most 7 days
    if (GetStorage().read(kStoredNotificationLimit)) {
      times = times.take(7).toList();
    }

    final MyNotificationType notifType =
        MyNotificationType.values[GetStorage().read(kNotificationType)];

    switch (notifType) {
      case MyNotificationType.noazan:
        DebugToast.show('Notification: Default sound');
        _defaultScheduler(
            appLocalizationsInstance, times, currentDateTime, currentDaerah);
        break;
      case MyNotificationType.azan:
        DebugToast.show('Notification: Azan');
        _azanScheduler(
            appLocalizationsInstance, times, currentDateTime, currentDaerah);
        break;
      case MyNotificationType.shortAzan:
        _azanScheduler(
            appLocalizationsInstance, times, currentDateTime, currentDaerah,
            short: true);
    }

    scheduleAlertNotification(
      id: 2190,
      title: appLocalizationsInstance.notifMonthlyReminderTitle,
      body: appLocalizationsInstance.notifMonthlyReminderDesc,
      // if month (12 + 1) = 13, it will auto-increment to next year
      //2021-01-01 00:05:00.000+0800
      scheduledTime: TZDateTime.local(
          currentDateTime.year, currentDateTime.month + 1, 1, 0, 5),
    );

    //This timestamp is later used to determine wether notification should be updated or not
    GetStorage()
        .write(kStoredLastUpdateNotif, DateTime.now().millisecondsSinceEpoch);
  }

  /// Classic Notification Scheduler, default notification sound
  static Future<void> _defaultScheduler(
      AppLocalizations appLocalizations,
      List<Prayers> times,
      DateTime currentDateTime,
      String currentLocation) async {
    for (var dayTime in times) {
      if (dayTime.fajr.isAfter(currentDateTime)) {
        //to make sure the time is in future
        await scheduleSinglePrayerNotification(
          name: 'Fajr',
          // Note: previosly, there was a bug with this id.
          // Read more: https://github.com/mptwaktusolat/app_waktu_solat_malaysia/issues/201
          id: int.parse(dayTime.fajr.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.fajrName),
          scheduledTime: TZDateTime.from(dayTime.fajr, local),
          body: appLocalizations.notifIn(currentLocation),
        );
      }
      if (dayTime.syuruk.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Syuruk',
          id: int.parse(dayTime.syuruk.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.sunriseName),
          body: appLocalizations.notifIn(currentLocation),
          summary: appLocalizations.notifEndSubh,
          scheduledTime: TZDateTime.from(dayTime.syuruk, local),
        );
      }
      if (dayTime.dhuhr.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Zuhr',
          id: int.parse(dayTime.dhuhr.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.dhuhrName),
          body: appLocalizations.notifIn(currentLocation),
          summary:
              dayTime.dhuhr.weekday == DateTime.friday ? 'Salam Jumaat' : null,
          scheduledTime: TZDateTime.from(dayTime.dhuhr, local),
        );
      }
      if (dayTime.asr.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Asr',
          id: int.parse(dayTime.asr.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.asrName),
          body: appLocalizations.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.asr, local),
        );
      }
      if (dayTime.maghrib.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Maghrib',
          id: int.parse(dayTime.maghrib.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.maghribName),
          body: appLocalizations.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.maghrib, local),
        );
      }
      if (dayTime.isha.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Isya\'',
          id: int.parse(dayTime.isha.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.ishaName),
          body: appLocalizations.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.isha, local),
        );
      }
    }
  }

  /// Notification but with azan
  static void _azanScheduler(AppLocalizations appLocalizations,
      List<Prayers> times, DateTime currentDateTime, String currentLocation,
      {bool short = false}) async {
    for (var dayTime in times) {
      if (dayTime.fajr.isAfter(currentDateTime)) {
        //to make sure the time is in future
        await scheduleSingleAzanNotification(
          name: short ? 'Fajr short' : 'Fajr',
          id: int.parse(dayTime.fajr.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.fajrName),
          scheduledTime: TZDateTime.from(dayTime.fajr, local),
          body: appLocalizations.notifIn(currentLocation),
          customSound: short ? 'azan_short_lamy2005' : 'azan_hejaz2013_fajr',
        );
      }
      if (dayTime.syuruk.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Syuruk',
          id: int.parse(dayTime.syuruk.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.sunriseName),
          body: appLocalizations.notifIn(currentLocation),
          summary: appLocalizations.notifEndSubh,
          scheduledTime: TZDateTime.from(dayTime.syuruk, local),
        );
      }
      if (dayTime.dhuhr.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
          name: short ? 'Zuhr short' : 'Zuhr',
          id: int.parse(dayTime.dhuhr.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.dhuhrName),
          body: appLocalizations.notifIn(currentLocation),
          summary:
              dayTime.dhuhr.weekday == DateTime.friday ? 'Salam Jumaat' : null,
          scheduledTime: TZDateTime.from(dayTime.dhuhr, local),
          customSound: short ? 'azan_short_lamy2005' : 'azan_kurdhi2010',
        );
      }
      if (dayTime.asr.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
          name: short ? 'Asr short' : 'Asr',
          id: int.parse(dayTime.asr.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.asrName),
          body: appLocalizations.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.asr, local),
          customSound: short ? 'azan_short_lamy2005' : 'azan_kurdhi2010',
        );
      }
      if (dayTime.maghrib.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
          name: short ? 'Maghrib short' : 'Maghrib',
          id: int.parse(dayTime.maghrib.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.maghribName),
          body: appLocalizations.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.maghrib, local),
          customSound: short ? 'azan_short_lamy2005' : 'azan_kurdhi2010',
        );
      }
      if (dayTime.isha.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
          name: short ? 'Isya\' short' : 'Isya\'',
          id: int.parse(dayTime.isha.millisecondsSinceEpoch
              .toString()
              .replaceAll(RegExp(r'0+$'), "")),
          title: appLocalizations.notifItsTime(appLocalizations.ishaName),
          body: appLocalizations.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.isha, local),
          customSound: short ? 'azan_short_lamy2005' : 'azan_kurdhi2010',
        );
      }
    }
  }
}
