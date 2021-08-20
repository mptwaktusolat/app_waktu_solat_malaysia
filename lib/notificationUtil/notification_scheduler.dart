import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:timezone/timezone.dart' hide LocationDatabase;
import '../utils/debug_toast.dart';
import '../CONSTANTS.dart';
import '../locationUtil/locationDatabase.dart';
import 'notifications_helper.dart';

// https://gist.github.com/taciomedeiros/50472cf94c742befba720853e9d598b6

final IsolateHandler isolateHandler = IsolateHandler();

void schedulePrayNotification(List<dynamic> times) async {
  await FlutterLocalNotificationsPlugin().cancelAll(); //reset all
  var _currentDateTime = DateTime.now();

  String currentLocation =
      LocationDatabase.getDaerah(GetStorage().read(kStoredGlobalIndex));

  //if true, notification is scheduled by at most 7 days
  if (GetStorage().read(kStoredNotificationLimit)) {
    times = times.take(7).toList();
  }

  DebugToast.show('SCHEDULING ${times.length} notifications');

  // for debug dialog
  GetStorage().write(kNumberOfNotifsScheduled, times.length);

  for (var dayTime in times) {
    DateTime subuhDateTime =
        DateTime.fromMillisecondsSinceEpoch(dayTime[0] * 1000);
    DateTime syurukDateTime =
        DateTime.fromMillisecondsSinceEpoch(dayTime[1] * 1000);
    DateTime zuhrDateTime =
        DateTime.fromMillisecondsSinceEpoch(dayTime[2] * 1000);
    DateTime asarDateTime =
        DateTime.fromMillisecondsSinceEpoch(dayTime[3] * 1000);
    DateTime maghribDateTime =
        DateTime.fromMillisecondsSinceEpoch(dayTime[4] * 1000);
    DateTime isyakDateTime =
        DateTime.fromMillisecondsSinceEpoch(dayTime[5] * 1000);

    if (subuhDateTime.isAfter(_currentDateTime)) {
      //to make sure the time is in future
      await schedulePrayerNotification(
        name: 'Fajr',
        id: subuhDateTime.microsecondsSinceEpoch ~/ 10000,
        title: 'It\'s Subuh',
        scheduledTime: TZDateTime.from(subuhDateTime, local),
        body: 'in ' + currentLocation,
      );
    }
    if (syurukDateTime.isAfter(_currentDateTime)) {
      await schedulePrayerNotification(
        name: 'Syuruk',
        id: syurukDateTime.microsecondsSinceEpoch ~/ 10000,
        title: 'It\'s Syuruk',
        body: 'in ' + currentLocation,
        summary: 'Ends of Subuh',
        scheduledTime: TZDateTime.from(syurukDateTime, local),
      );
    }
    if (zuhrDateTime.isAfter(_currentDateTime)) {
      await schedulePrayerNotification(
        name: 'Zuhr',
        id: zuhrDateTime.microsecondsSinceEpoch ~/ 10000,
        title: 'It\'s Zohor',
        body: 'in ' + currentLocation,
        summary: zuhrDateTime.day == DateTime.friday ? 'Salam Jumaat' : null,
        scheduledTime: TZDateTime.from(zuhrDateTime, local),
      );
    }
    if (asarDateTime.isAfter(_currentDateTime)) {
      await schedulePrayerNotification(
        name: 'Asr',
        id: asarDateTime.microsecondsSinceEpoch ~/ 10000,
        title: 'It\'s Asar',
        body: 'in ' + currentLocation,
        scheduledTime: TZDateTime.from(asarDateTime, local),
      );
    }
    if (maghribDateTime.isAfter(_currentDateTime)) {
      await schedulePrayerNotification(
        name: 'Maghrib',
        id: maghribDateTime.microsecondsSinceEpoch ~/ 10000,
        title: 'It\'s Maghrib',
        body: 'in ' + currentLocation,
        scheduledTime: TZDateTime.from(maghribDateTime, local),
      );
    }
    if (isyakDateTime.isAfter(_currentDateTime)) {
      await schedulePrayerNotification(
        name: 'Isya\'',
        id: isyakDateTime.microsecondsSinceEpoch ~/ 10000,
        title: 'It\'s Isyak',
        body: 'in ' + currentLocation,
        scheduledTime: TZDateTime.from(isyakDateTime, local),
      );
    }
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

  var _endOperation = DateTime.now();
  var _timeTaken = _endOperation.difference(_currentDateTime);
  DebugToast.show('Finish schedule notif. after $_timeTaken');

  killCurrentScheduleNotifications();
}

startScheduleNotifications(String _remindersAsString) {
  killCurrentScheduleNotifications();
  isolateHandler.spawn(
    entryPoint,
    name: "scheduleNotifications",
    onReceive: schedulePrayNotification,
    onInitialized: () => isolateHandler.send(
      _remindersAsString,
      to: "scheduleNotifications",
    ),
  );
}

void killCurrentScheduleNotifications() {
  if (isolateHandler.isolates.containsKey('scheduleNotifications')) {
    isolateHandler.kill('scheduleNotifications');
  }
}

void entryPoint(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);
  messenger.listen((message) {
    messenger.send(message);
  });
}
