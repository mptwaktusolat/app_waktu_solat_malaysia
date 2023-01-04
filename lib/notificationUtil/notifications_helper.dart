import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

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
  await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
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
    '$name id', // Different prayer time have different id
    '$name notification',
    channelDescription: 'Scheduled daily prayer notification',
    priority: Priority.max,
    importance: Importance.high,
    styleInformation: styleInformation,
    category: AndroidNotificationCategory.alarm,
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

/// Single prayer azan notification
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
    '$name azan id', // Different prayer time have different id
    '$name azan notification',
    channelDescription: 'Scheduled daily prayer azan',
    priority: Priority.max,
    importance: Importance.high,
    styleInformation: styleInformation,
    when: scheduledTime.millisecondsSinceEpoch,
    playSound: true,
    category: AndroidNotificationCategory.alarm,

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

/// Schedule alert notification
Future<void> scheduleAlertNotification(
    {required int id,
    required String title,
    required String body,
    String? payload,
    required TZDateTime scheduledTime}) async {
  BigTextStyleInformation styleInformation = BigTextStyleInformation(body);
  var androidSpecifics = AndroidNotificationDetails(
    'Alert id',
    'Alert notification',
    channelDescription: 'Alerts and reminders to user',
    priority: Priority.defaultPriority,
    importance: Importance.high,
    category: AndroidNotificationCategory.reminder,
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

/// To test if the notification is working
Future<void> showDebugNotification() async {
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
