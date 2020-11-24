import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifs;
import 'package:rxdart/subjects.dart' as rxSub;

final rxSub.BehaviorSubject<NotificationClass>
    didReceiveLocalNotificationSubject =
    rxSub.BehaviorSubject<NotificationClass>();
final rxSub.BehaviorSubject<String> selectNotificationSubject =
    rxSub.BehaviorSubject<String>();

class NotificationClass {
  final int id;
  final String title;
  final String body;
  final String payload;

  NotificationClass({this.id, this.body, this.payload, this.title});
}

Future<void> initNotifications(
    notifs.FlutterLocalNotificationsPlugin notifsPlugin) async {
  var initializationSettingsAndroid =
      notifs.AndroidInitializationSettings('icon');
  var initializationSettingsIOS = notifs.IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(NotificationClass(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = notifs.InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await notifsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  print("Notifications initialised successfully");
}

void requestIOSPermissions(
    notifs.FlutterLocalNotificationsPlugin notifsPlugin) {
  notifsPlugin
      .resolvePlatformSpecificImplementation<
          notifs.IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

Future<void> scheduleNotification(
    {notifs.FlutterLocalNotificationsPlugin notifsPlugin,
    String id,
    String title,
    String body,
    DateTime scheduledTime}) async {
  var androidSpecifics = notifs.AndroidNotificationDetails(
    id, // This specifies the ID of the Notification
    '$title notification', // This specifies the name of the notification channel
    'A scheduled prayer notification', //This specifies the description of the channel
    // icon: 'icon',
    color: Color(0xFF19e3cb),
  );
  var iOSSpecifics = notifs.IOSNotificationDetails();
  var platformChannelSpecifics =
      notifs.NotificationDetails(android: androidSpecifics, iOS: iOSSpecifics);
  await notifsPlugin.zonedSchedule(
      int.parse(id), title, body, scheduledTime, platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: notifs
          .UILocalNotificationDateInterpretation
          .absoluteTime); // This literally schedules the notification
}

//anywhere in code:
// void scheduleNoti() {
//   var newTime = DateTime.fromMillisecondsSinceEpoch(
//       DateTime.now().millisecondsSinceEpoch);
//   for (var i = 1; i < 6; i++) {
//     scheduleNotification(
//         notifsPlugin: notifsPlugin,
//         id: '$i',
//         body: 'Scehdule notif #$i',
//         title: 'Minutes noti ',
//         scheduledTime: tz.TZDateTime.from(
//             newTime.add(Duration(minutes: 20 * i)), tz.local));
//   }
// }

// Future<void> _zonedScheduleNotification() async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'scheduled title',
//         'scheduled body',
//         tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails('your channel id',
//                 'your channel name', 'your channel description')),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);
//   }

//   Future<void> _scheduleDailyTenAMNotification() async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'daily scheduled notification title',
//         'daily scheduled notification body',
//         _nextInstanceOfTenAM(),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//               'daily notification channel id',
//               'daily notification channel name',
//               'daily notification description'),
//         ),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time);
//   }

//   Future<void> _scheduleWeeklyTenAMNotification() async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'weekly scheduled notification title',
//         'weekly scheduled notification body',
//         _nextInstanceOfTenAM(),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//               'weekly notification channel id',
//               'weekly notification channel name',
//               'weekly notificationdescription'),
//         ),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
//   }

//   Future<void> _scheduleWeeklyMondayTenAMNotification() async {
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'weekly scheduled notification title',
//         'weekly scheduled notification body',
//         _nextInstanceOfMondayTenAM(),
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//               'weekly notification channel id',
//               'weekly notification channel name',
//               'weekly notificationdescription'),
//         ),
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
//   }

// tz.TZDateTime _nextInstanceOfTenAM() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }

//   tz.TZDateTime _nextInstanceOfMondayTenAM() {
//     tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
//     while (scheduledDate.weekday != DateTime.monday) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
