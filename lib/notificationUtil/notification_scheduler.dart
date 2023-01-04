import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' hide LocationDatabase;

import '../CONSTANTS.dart';
import '../location_utils/location_database.dart';
import '../models/jakim_esolat_model.dart';
import '../utils/debug_toast.dart';
import '../views/Settings%20part/NotificationSettingPage.dart';
import 'notifications_helper.dart';

class MyNotifScheduler {
  static void schedulePrayNotification(
      BuildContext context, List<PrayerTime> times) async {
    await FlutterLocalNotificationsPlugin().cancelAll(); //reset all
    var currentDateTime = DateTime.now();

    String currentDaerah =
        LocationDatabase.daerah(GetStorage().read(kStoredLocationJakimCode));

    //if true, notification is scheduled by at most 7 days
    if (GetStorage().read(kStoredNotificationLimit)) {
      times = times.take(7).toList();
    }

    MyNotificationType notifType =
        MyNotificationType.values[GetStorage().read(kNotificationType)];

    switch (notifType) {
      case MyNotificationType.noazan:
        DebugToast.show('Notification: Default sound');
        _defaultScheduler(context, times, currentDateTime, currentDaerah);
        break;
      case MyNotificationType.azan:
        DebugToast.show('Notification: Azan');
        _azanScheduler(context, times, currentDateTime, currentDaerah);
        break;
      case MyNotificationType.shortAzan:
        _azanScheduler(context, times, currentDateTime, currentDaerah,
            short: true);
    }

    scheduleAlertNotification(
      id: 2190,
      title: AppLocalizations.of(context)!.notifMonthlyReminderTitle,
      body: AppLocalizations.of(context)!.notifMonthlyReminderDesc,
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
      BuildContext context,
      List<PrayerTime> times,
      DateTime currentDateTime,
      String currentLocation) async {
    for (var dayTime in times) {
      if (dayTime.fajr.isAfter(currentDateTime)) {
        //to make sure the time is in future
        await scheduleSinglePrayerNotification(
          name: 'Fajr',
          id: int.parse(
              dayTime.fajr.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.fajrName),
          scheduledTime: TZDateTime.from(dayTime.fajr, local),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
        );
      }
      if (dayTime.syuruk.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Syuruk',
          id: int.parse(
              dayTime.syuruk.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.sunriseName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          summary: AppLocalizations.of(context)!.notifEndSubh,
          scheduledTime: TZDateTime.from(dayTime.syuruk, local),
        );
      }
      if (dayTime.dhuhr.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Zuhr',
          id: int.parse(
              dayTime.dhuhr.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.dhuhrName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          summary:
              dayTime.dhuhr.weekday == DateTime.friday ? 'Salam Jumaat' : null,
          scheduledTime: TZDateTime.from(dayTime.dhuhr, local),
        );
      }
      if (dayTime.asr.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Asr',
          id: int.parse(
              dayTime.asr.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.asrName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.asr, local),
        );
      }
      if (dayTime.maghrib.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Maghrib',
          id: int.parse(
              dayTime.maghrib.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.maghribName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.maghrib, local),
        );
      }
      if (dayTime.isha.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Isya\'',
          id: int.parse(
              dayTime.isha.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.ishaName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.isha, local),
        );
      }
    }
  }

  /// Notification but with azan
  static void _azanScheduler(BuildContext context, List<PrayerTime> times,
      DateTime currentDateTime, String currentLocation,
      {bool short = false}) async {
    for (var dayTime in times) {
      if (dayTime.fajr.isAfter(currentDateTime)) {
        //to make sure the time is in future
        await scheduleSingleAzanNotification(
          name: short ? 'Fajr short' : 'Fajr',
          id: int.parse(
              dayTime.fajr.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.fajrName),
          scheduledTime: TZDateTime.from(dayTime.fajr, local),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          customSound: short ? 'azan_short_lamy2005' : 'azan_hejaz2013_fajr',
        );
      }
      if (dayTime.syuruk.isAfter(currentDateTime)) {
        await scheduleSinglePrayerNotification(
          name: 'Syuruk',
          id: int.parse(
              dayTime.syuruk.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.sunriseName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          summary: AppLocalizations.of(context)!.notifEndSubh,
          scheduledTime: TZDateTime.from(dayTime.syuruk, local),
        );
      }
      if (dayTime.dhuhr.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
          name: short ? 'Zuhr short' : 'Zuhr',
          id: int.parse(
              dayTime.dhuhr.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.dhuhrName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          summary:
              dayTime.dhuhr.weekday == DateTime.friday ? 'Salam Jumaat' : null,
          scheduledTime: TZDateTime.from(dayTime.dhuhr, local),
          customSound: short ? 'azan_short_lamy2005' : 'azan_hejaz2013_fajr',
        );
      }
      if (dayTime.asr.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
          name: short ? 'Asr short' : 'Asr',
          id: int.parse(
              dayTime.asr.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.asrName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.asr, local),
          customSound: short ? 'azan_short_lamy2005' : 'azan_hejaz2013_fajr',
        );
      }
      if (dayTime.maghrib.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
          name: short ? 'Maghrib short' : 'Maghrib',
          id: int.parse(
              dayTime.maghrib.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.maghribName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.maghrib, local),
          customSound: short ? 'azan_short_lamy2005' : 'azan_hejaz2013_fajr',
        );
      }
      if (dayTime.isha.isAfter(currentDateTime)) {
        await scheduleSingleAzanNotification(
          name: short ? 'Isya\' short' : 'Isya\'',
          id: int.parse(
              dayTime.isha.millisecondsSinceEpoch.toString().substring(5)),
          title: AppLocalizations.of(context)!
              .notifItsTime(AppLocalizations.of(context)!.ishaName),
          body: AppLocalizations.of(context)!.notifIn(currentLocation),
          scheduledTime: TZDateTime.from(dayTime.isha, local),
          customSound: short ? 'azan_short_lamy2005' : 'azan_hejaz2013_fajr',
        );
      }
    }
  }
}
