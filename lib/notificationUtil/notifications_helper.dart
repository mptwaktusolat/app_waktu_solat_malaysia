import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifs;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart' as rxsub;
import '../CONSTANTS.dart';

final rxsub.BehaviorSubject<NotificationClass>
    didReceiveLocalNotificationSubject =
    rxsub.BehaviorSubject<NotificationClass>();
final rxsub.BehaviorSubject<String> selectNotificationSubject =
    rxsub.BehaviorSubject<String>();

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
      const notifs.AndroidInitializationSettings('icon');
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
}

// void requestIOSPermissions(
//     notifs.FlutterLocalNotificationsPlugin notifsPlugin) {
//   notifsPlugin
//       .resolvePlatformSpecificImplementation<
//           notifs.IOSFlutterLocalNotificationsPlugin>()
//       ?.requestPermissions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
// }

void configureSelectNotificationSubject(BuildContext context) {
  selectNotificationSubject.stream.listen((String payload) async {
    if (payload == kPayloadMonthly) {
      Fluttertoast.showToast(
          msg:
              'Please wait for a few seconds for the notification to be resheduled.',
          toastLength: Toast.LENGTH_LONG);
    } else if (payload == kPayloadDebug) {
      Fluttertoast.showToast(
          msg: 'Debug payload here!', toastLength: Toast.LENGTH_SHORT);
    }
  });
}

Future<void> schedulePrayerNotification(
    //for main prayer functionality
    {@required notifs.FlutterLocalNotificationsPlugin notifsPlugin,
    @required String name,
    @required int id,
    @required String title,
    @required String body,
    @required DateTime scheduledTime}) async {
  BigTextStyleInformation styleInformation = BigTextStyleInformation(body);
  var androidSpecifics = notifs.AndroidNotificationDetails(
    '$name id', // This specifies the ID of the Notification
    '$name notification', // This specifies the name of the notification channel
    'Scheduled daily prayer notification', //This specifies the description of the channel
    priority: notifs.Priority.max,
    importance: notifs.Importance.high,
    styleInformation: styleInformation,
    color: const Color(0xFF19e3cb),
  );
  var iOSSpecifics = const notifs.IOSNotificationDetails();
  var platformChannelSpecifics =
      notifs.NotificationDetails(android: androidSpecifics, iOS: iOSSpecifics);
  await notifsPlugin.zonedSchedule(
      id, title, body, scheduledTime, platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: notifs
          .UILocalNotificationDateInterpretation
          .absoluteTime); // This literally schedules the notification
}

Future<void> scheduleAlertNotification(
    //for main prayer functionality
    {@required notifs.FlutterLocalNotificationsPlugin notifsPlugin,
    @required int id,
    @required String title,
    @required String body,
    String payload,
    @required DateTime scheduledTime}) async {
  BigTextStyleInformation styleInformation = BigTextStyleInformation(body);
  var androidSpecifics = notifs.AndroidNotificationDetails(
    'Alert id', // This specifies the ID of the Notification
    'Alert notification', // This specifies the name of the notification channel
    'Alerts and reminders to user', //This specifies the description of the channel
    priority: notifs.Priority.defaultPriority,
    importance: notifs.Importance.high,
    styleInformation: styleInformation,
    color: const Color(0xFFfcbd00),
  );

  var iOSSpecifics = const notifs.IOSNotificationDetails();
  var platformChannelSpecifics =
      notifs.NotificationDetails(android: androidSpecifics, iOS: iOSSpecifics);
  await notifsPlugin.zonedSchedule(
      id, title, body, scheduledTime, platformChannelSpecifics,
      androidAllowWhileIdle: true,
      payload: payload,
      uiLocalNotificationDateInterpretation: notifs
          .UILocalNotificationDateInterpretation
          .absoluteTime); // This literally schedules the notification
}

Future<void> showDebugNotification() async {
  //to test notifocation can show?
  const notifs.AndroidNotificationDetails androidPlatformChannelSpecifics =
      notifs.AndroidNotificationDetails(
          'Debug id', 'Debug channel', 'Notification debug test',
          importance: Importance.defaultImportance,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await FlutterLocalNotificationsPlugin().show(
      0, 'Debug notifs.', 'For developer purposes', platformChannelSpecifics);
}
