import 'package:get_storage/get_storage.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:waktusolatmalaysia/main.dart';
import 'package:waktusolatmalaysia/views/GetPrayerTime.dart';
import 'notifications_helper.dart';
import 'package:timezone/timezone.dart' as tz;
import '../CONSTANTS.dart';

// https://gist.github.com/taciomedeiros/50472cf94c742befba720853e9d598b6

final IsolateHandler isolateHandler = IsolateHandler();
DateTime currentDate = DateTime.now();

void schedulePrayNotification(List<dynamic> times) async {
  await Future.delayed(Duration(milliseconds: 500));
  await notifsPlugin.cancelAll(); //reset all

  String currentLocation =
      locationDatabase.getDaerah(GetStorage().read(kStoredGlobalIndex));
  print(currentLocation);

  var currentTime = DateTime.now().millisecondsSinceEpoch;

  for (int i = 0; i < times.length; i++) {
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
        title: 'It\'s Fajr',
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
          title: 'It\'s Zuhr',
          body: 'in ' + currentLocation,
          scheduledTime: tz.TZDateTime.from(
              DateTime.fromMillisecondsSinceEpoch(zuhrTimeEpoch), tz.local));
    }
    if (!(asarTimeEpoch < currentTime)) {
      await schedulePrayerNotification(
          name: 'Asr',
          notifsPlugin: notifsPlugin,
          id: (asarTimeEpoch / 1000).truncate(),
          title: 'It\'s Asr',
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
          title: 'It\'s Isya\'',
          body: 'in ' + currentLocation,
          scheduledTime: tz.TZDateTime.from(
              DateTime.fromMillisecondsSinceEpoch(isyakTimeEpoch), tz.local));
    }

    print('Notification scheduled');
    print('Subuh @ $subuhTimeEpoch');
    print('Syuruk @ $syurukTimeEpoch');
    print('Zohor @ $zuhrTimeEpoch');
    print('Asar @ $asarTimeEpoch');
    print('Maghrib @ $maghribTimeEpoch');
    print('Isyak @ $isyakTimeEpoch');
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
  if (isolateHandler.isolates.containsKey('scheduleNotifications'))
    isolateHandler.kill('scheduleNotifications');
}

void entryPoint(Map<String, dynamic> context) {
  final messenger = HandledIsolate.initialize(context);
  messenger.listen((message) {
    messenger.send(message);
  });
}
