import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/subjects.dart' as rxsub;
import 'package:timezone/timezone.dart';

import '../CONSTANTS.dart';

final rxsub.BehaviorSubject<NotificationClass>
    didReceiveLocalNotificationSubject =
    rxsub.BehaviorSubject<NotificationClass>();
final rxsub.BehaviorSubject<String?> selectNotificationSubject =
    rxsub.BehaviorSubject<String?>();

class NotificationClass {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;

  NotificationClass({this.id, this.body, this.payload, this.title});
}

Future<void> initNotifications() async {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('icon');

  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await FlutterLocalNotificationsPlugin().initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: $payload');
        selectNotificationSubject.add(payload);
      }
    },
  );
}

void configureSelectNotificationSubject() {
  selectNotificationSubject.stream.listen((String? payload) async {
    if (payload == kPayloadMonthly) {
      Fluttertoast.showToast(
          msg:
              'Please wait for a few seconds for the notification to be resheduled',
          toastLength: Toast.LENGTH_LONG);
    } else if (payload == kPayloadDebug) {
      Fluttertoast.showToast(
          msg: 'Debug payload here!', toastLength: Toast.LENGTH_SHORT);
    }
  });
}

/// Single prayer notification without azan
Future<void> scheduleSinglePrayerNotification({
  required String name,
  required int id,
  required String title,
  required String body,
  required TZDateTime scheduledTime,
  String? summary,
}) async {
  BigTextStyleInformation styleInformation =
      BigTextStyleInformation(body, summaryText: summary);
  var androidSpecifics = AndroidNotificationDetails(
    '$name id', // This specifies the ID of the Notification
    '$name notification', // This specifies the name of the notification channel
    channelDescription:
        'Scheduled daily prayer notification', //This specifies the description of the channel
    priority: Priority.max,
    importance: Importance.high,
    styleInformation: styleInformation,
    when: scheduledTime.millisecondsSinceEpoch,
    color: const Color(0xFF19e3cb),
  );
  var platformChannelSpecifics = NotificationDetails(android: androidSpecifics);

  await FlutterLocalNotificationsPlugin().zonedSchedule(
      id, title, body, scheduledTime, platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime); // This literally schedules the notification
}

/// Single prayer notification without azan
Future<void> scheduleSingleAzanNotification(
    //for main prayer functionality
    {required String name,
    required int id,
    required String title,
    required String body,
    required TZDateTime scheduledTime,
    required String customSound,
    String? summary}) async {
  BigTextStyleInformation styleInformation =
      BigTextStyleInformation(body, summaryText: summary);
  var androidSpecifics = AndroidNotificationDetails(
    '$name azan id', // This specifies the ID of the Notification
    '$name azan notification', // This specifies the name of the notification channel
    channelDescription:
        'Scheduled daily prayer azan', //This specifies the description of the channel
    priority: Priority.max,
    importance: Importance.high,
    styleInformation: styleInformation,
    when: scheduledTime.millisecondsSinceEpoch,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(customSound),
    color: const Color(0xFF19e3cb),
  );
  var platformChannelSpecifics = NotificationDetails(android: androidSpecifics);

  await FlutterLocalNotificationsPlugin().zonedSchedule(
      id, title, body, scheduledTime, platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime); // This literally schedules the notification
}

Future<void> scheduleAlertNotification(
    //for main prayer functionality
    {required int id,
    required String title,
    required String body,
    String? payload,
    required TZDateTime scheduledTime}) async {
  BigTextStyleInformation styleInformation = BigTextStyleInformation(body);
  var androidSpecifics = AndroidNotificationDetails(
    'Alert id', // This specifies the ID of the Notification
    'Alert notification', // This specifies the name of the notification channel
    channelDescription:
        'Alerts and reminders to user', //This specifies the description of the channel
    priority: Priority.defaultPriority,
    importance: Importance.high,
    styleInformation: styleInformation,
    color: const Color(0xFFfcbd00),
  );

  var platformChannelSpecifics = NotificationDetails(android: androidSpecifics);
  await FlutterLocalNotificationsPlugin().zonedSchedule(
      id, title, body, scheduledTime, platformChannelSpecifics,
      androidAllowWhileIdle: true,
      payload: payload,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime); // This literally schedules the notification
}

Future<void> showDebugNotification() async {
  //to test notifocation can show?
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'Debug id',
    'Debug channel',
    channelDescription: 'Notification debug test',
    importance: Importance.defaultImportance,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await FlutterLocalNotificationsPlugin()
      .show(0, 'Debug ', 'For developer purposes', platformChannelSpecifics);
}
