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
final _notifsPlugin = FlutterLocalNotificationsPlugin();
DateTime currentDate = DateTime.now();

void schedulePrayNotification(List<dynamic> times) async {
  await _notifsPlugin.cancelAll(); //reset all

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
        notifsPlugin: _notifsPlugin,
        id: (subuhTimeEpoch / 1000).truncate(),
        title: 'It\'s Subuh',
        scheduledTime:
            TZDateTime.fromMillisecondsSinceEpoch(local, subuhTimeEpoch),
        body: 'in ' + currentLocation,
      );
    }
    if (!(syurukTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Syuruk',
          notifsPlugin: _notifsPlugin,
          id: (syurukTimeEpoch / 1000).truncate(),
          title: 'It\'s Syuruk',
          body: 'in ' + currentLocation,
          scheduledTime:
              TZDateTime.fromMillisecondsSinceEpoch(local, syurukTimeEpoch));
    }
    if (!(zuhrTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Zuhr',
          notifsPlugin: _notifsPlugin,
          id: (zuhrTimeEpoch / 1000).truncate(),
          title: 'It\'s Zohor',
          body: 'in ' + currentLocation,
          scheduledTime:
              TZDateTime.fromMillisecondsSinceEpoch(local, zuhrTimeEpoch));
    }
    if (!(asarTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Asr',
          notifsPlugin: _notifsPlugin,
          id: (asarTimeEpoch / 1000).truncate(),
          title: 'It\'s Asar',
          body: 'in ' + currentLocation,
          scheduledTime:
              TZDateTime.fromMillisecondsSinceEpoch(local, asarTimeEpoch));
    }
    if (!(maghribTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Maghrib',
          notifsPlugin: _notifsPlugin,
          id: (maghribTimeEpoch / 1000).truncate(),
          title: 'It\'s Maghrib',
          body: 'in ' + currentLocation,
          scheduledTime:
              TZDateTime.fromMillisecondsSinceEpoch(local, maghribTimeEpoch));
    }
    if (!(isyakTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
        name: 'Isya\'',
        notifsPlugin: _notifsPlugin,
        id: (isyakTimeEpoch / 1000).truncate(),
        title: 'It\'s Isyak',
        body: 'in ' + currentLocation,
        scheduledTime:
            TZDateTime.fromMillisecondsSinceEpoch(local, isyakTimeEpoch),
      );
    }
  }

  scheduleAlertNotification(
    notifsPlugin: _notifsPlugin,
    id: 2190,
    title: 'Monthly refresh reminder',
    body:
        'To continue receive prayer notification, open app at least once every month.',
    payload: kPayloadMonthly,
    // if month (12 + 1) = 13, it will auto-increment to next year
    //2021-01-01 00:05:00.000+0800
    scheduledTime:
        TZDateTime.local(currentDate.year, currentDate.month + 1, 1, 0, 5),
  );

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
