import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:waktusolatmalaysia/locationUtil/LocationData.dart';
import 'package:waktusolatmalaysia/notificationUtil/notifications_helper.dart';
import 'package:timezone/timezone.dart' as tz;
import '../CONSTANTS.dart';

class DebugWidgets {
  static Dialog debugDialog() {
    return Dialog(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          const Text(
            'Debug dialog (for dev)',
            textAlign: TextAlign.center,
          ),
          ListTile(
            title: const Text('Prayer time API calls'),
            subtitle:
                Text(GetStorage().read(kStoredApiPrayerCall) ?? 'no calls yet'),
            onLongPress: () {
              Clipboard.setData(ClipboardData(
                      text: GetStorage().read(kStoredApiPrayerCall) ??
                          'no calls yet'))
                  .then((value) => Fluttertoast.showToast(msg: 'Copied url'));
            },
          ),
          ListTile(
            title: const Text('Last position'),
            subtitle: Text(LocationData.position.toString() ?? 'no detect'),
            onLongPress: () {
              Clipboard.setData(ClipboardData(
                      text: LocationData.position.toString() ?? 'no detect'))
                  .then((value) =>
                      Fluttertoast.showToast(msg: 'Copied position'));
            },
          ),
          ListTile(
            title: const Text('Send immediate test notification'),
            onTap: () async {
              await showDebugNotification();
            },
          ),
          ListTile(
            title: const Text('Send alert test in one minute'),
            subtitle: const Text('Payload: $kPayloadDebug'),
            onTap: () async {
              await scheduleAlertNotification(
                  notifsPlugin: FlutterLocalNotificationsPlugin(),
                  title: 'debug payload',
                  id: 219, //randrom int haha
                  body: 'With payload',
                  payload: kPayloadDebug,
                  scheduledTime: tz.TZDateTime.now(tz.local).add(
                    const Duration(minutes: 1),
                  ));
            },
          ),
          ListTile(
              title: const Text('Global location index'),
              subtitle: Text('${GetStorage().read(kStoredGlobalIndex)}')),
          ListTile(
            title: const Text('Last update notification'),
            subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                    GetStorage().read(kStoredLastUpdateNotif))
                .toString()),
            onLongPress: () {
              Clipboard.setData(ClipboardData(
                      text:
                          GetStorage().read(kStoredLastUpdateNotif).toString()))
                  .then(
                      (value) => Fluttertoast.showToast(msg: 'Copied millis'));
            },
          ),
          ListTile(
            title: const Text('Number of scheduled notification'),
            subtitle:
                Text(GetStorage().read(kNumberOfNotifsScheduled).toString()),
          ),
          ListTile(
            title: const Text('Open in app review'),
            subtitle: const Text(
                'This should not be used frequently as the underlying API\'s enforce strict quotas.'),
            onTap: () async {
              final InAppReview inAppReview = InAppReview.instance;

              if (await inAppReview.isAvailable()) {
                inAppReview.requestReview();
              }
            },
          ),
        ],
      ),
    );
  }
}
