import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:timezone/timezone.dart' as tz;
import '../notificationUtil/notifications_helper.dart';
import '../locationUtil/LocationData.dart';
import '../utils/launchUrl.dart';
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
            subtitle: Text(LocationData.position?.toString() ?? 'no detect'),
            onLongPress: () {
              Clipboard.setData(ClipboardData(
                      text: LocationData.position?.toString() ?? 'no detect'))
                  .then((value) =>
                      Fluttertoast.showToast(msg: 'Copied position'));
            },
          ),
          ListTile(
            title: const Text('Send immediate test notification'),
            subtitle: const Text('Without azan'),
            onTap: () async {
              await showDebugNotification();
            },
          ),
          ListTile(
            title: const Text('Send azan test in 30 secs'),
            onTap: () async {
              await scheduleSinglePrayerNotification(
                  name: 'name',
                  id: 2321,
                  title: 'title',
                  body: 'body',
                  customSound: 'azan_hejaz2013_fajr',
                  scheduledTime: tz.TZDateTime.now(tz.local)
                      .add(const Duration(seconds: 30)));
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

  static Dialog hijriDialog() {
    return Dialog(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hijri offset: ${GetStorage().read(kHijriOffset)}',
            style: const TextStyle(fontSize: 26),
          ),
          ElevatedButton(
              onPressed: () {
                LaunchUrl.normalLaunchUrl(
                    url: 'https://mpt-hijri-converter.web.app/');
              },
              child: const Text('Open MPT Hijri'))
        ],
      ),
    ));
  }
}
