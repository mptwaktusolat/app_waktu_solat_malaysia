import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:waktusolatmalaysia/utils/debug_toast.dart';
import '../CONSTANTS.dart';
import '../locationUtil/locationDatabase.dart';
import '../main.dart';
import 'notifications_helper.dart';

// https://gist.github.com/taciomedeiros/50472cf94c742befba720853e9d598b6

final IsolateHandler isolateHandler = IsolateHandler();
DateTime currentDate = DateTime.now();

void schedulePrayNotification(List<dynamic> times) async {
  await notifsPlugin.cancelAll(); //reset all

  String currentLocation =
      LocationDatabase.getDaerah(GetStorage().read(kStoredGlobalIndex));
  var currentTime = DateTime.now().millisecondsSinceEpoch;
  int howMuchToSchedule;

  if (GetStorage().read(kStoredNotificationLimit)) {
    //should limit to 7
    howMuchToSchedule = times.length < 7 ? times.length : 7;
  } else {
    howMuchToSchedule = times.length;
  }

  DebugToast.show('SCHEDULING $howMuchToSchedule notifications');

  print('howMuchToSchedule is $howMuchToSchedule');
  // for debug dialog
  GetStorage().write(kNumberOfNotifsScheduled, howMuchToSchedule);

  for (int i = 0; i < howMuchToSchedule; i++) {
    //i denotes the day relative for today
    int subuhTimeEpoch = times[i][0] * 1000;
    int syurukTimeEpoch = times[i][1] * 1000;
    int zuhrTimeEpoch = times[i][2] * 1000;
    int asarTimeEpoch = times[i][3] * 1000;
    int maghribTimeEpoch = times[i][4] * 1000;
    int isyakTimeEpoch = times[i][5] * 1000;

    if (!(subuhTimeEpoch < currentTime)) {
      //to make sure the time is in future
      await schedulePrayerNotification(
        name: 'Fajr',
        notifsPlugin: notifsPlugin,
        id: (subuhTimeEpoch / 1000).truncate(),
        title: 'It\'s Subuh',
        scheduledTime: tz.TZDateTime.from(
            DateTime.fromMillisecondsSinceEpoch(subuhTimeEpoch), tz.local),
        body: 'in ' + currentLocation,
      );
    }
    if (!(syurukTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Syuruk',
          notifsPlugin: notifsPlugin,
          id: (syurukTimeEpoch / 1000).truncate(),
          title: 'It\'s Syuruk',
          body: 'in ' + currentLocation,
          scheduledTime: tz.TZDateTime.from(
              DateTime.fromMillisecondsSinceEpoch(syurukTimeEpoch), tz.local));
    }
    if (!(zuhrTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Zuhr',
          notifsPlugin: notifsPlugin,
          id: (zuhrTimeEpoch / 1000).truncate(),
          title: 'It\'s Zohor',
          body: 'in ' + currentLocation,
          scheduledTime: tz.TZDateTime.from(
              DateTime.fromMillisecondsSinceEpoch(zuhrTimeEpoch), tz.local));
    }
    if (!(asarTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Asr',
          notifsPlugin: notifsPlugin,
          id: (asarTimeEpoch / 1000).truncate(),
          title: 'It\'s Asar',
          body: 'in ' + currentLocation,
          scheduledTime: tz.TZDateTime.from(
              DateTime.fromMillisecondsSinceEpoch(asarTimeEpoch), tz.local));
    }
    if (!(maghribTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Maghrib',
          notifsPlugin: notifsPlugin,
          id: (maghribTimeEpoch / 1000).truncate(),
          title: 'It\'s Maghrib',
          body: 'in ' + currentLocation,
          scheduledTime: tz.TZDateTime.from(
              DateTime.fromMillisecondsSinceEpoch(maghribTimeEpoch), tz.local));
    }
    if (!(isyakTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Isya\'',
          notifsPlugin: notifsPlugin,
          id: (isyakTimeEpoch / 1000).truncate(),
          title: 'It\'s Isyak',
          body: 'in ' + currentLocation,
          scheduledTime: tz.TZDateTime.from(
              DateTime.fromMillisecondsSinceEpoch(isyakTimeEpoch), tz.local));
    }

    print('Notification scheduled #${i + 1}');
  }

  scheduleAlertNotification(
    notifsPlugin: notifsPlugin,
    id: 2190,
    title: 'Monthly refresh reminder',
    body:
        'To continue receive prayer notification, open app at least once every month.',
    payload: kPayloadMonthly,
    scheduledTime: tz.TZDateTime.local(currentDate.year, currentDate.month + 1,
        1, 0, 5), //2021-01-01 00:05:00.000+0800
  );

  print('DONE SCHEDULING NOTIFS');
  DebugToast.show('FINISH SCHEDULE NOTIFS');

  //This timestamp is later used to determine wether notification should be updated or not
  GetStorage()
      .write(kStoredLastUpdateNotif, DateTime.now().millisecondsSinceEpoch);

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
