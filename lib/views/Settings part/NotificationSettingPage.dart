import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'troubleshoot_notif.dart';
import '../../CONSTANTS.dart';
import '../../utils/cupertinoSwitchListTile.dart';
import '../../utils/custom_navigator_pop.dart';

class NotificationPageSetting extends StatefulWidget {
  const NotificationPageSetting({Key key}) : super(key: key);
  @override
  _NotificationPageSettingState createState() =>
      _NotificationPageSettingState();
}

class _NotificationPageSettingState extends State<NotificationPageSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(padding: EdgeInsets.all(8.0), child: Text('Basic')),
          Card(
            child: ListTile(
              title: const Text('App notification System Setting'),
              isThreeLine: true,
              subtitle: const Text(
                  'Customize sound, toggle channel of prayer notification etc.'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.launch_rounded),
                ],
              ),
              onTap: () async {
                await AppSettings.openNotificationSettings();
              },
            ),
          ),
          const Padding(
              padding: EdgeInsets.all(8.0), child: Text('Troubleshooting')),
          Card(
            child: ListTile(
              title: const Text('Fix notification not showing on some devices'),
              subtitle: const Text('Example: Xiaomi / Redmi, Realme etc.'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TroubleshootNotif(),
                  )),
            ),
          ),
          const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Advanced troubleshooting')),
          Card(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CupertinoSwitchListTile(
                  activeColor: CupertinoColors.activeBlue,
                  title: const Text('Limit notification scheduling'),
                  subtitle: const Text(
                      'Enable if you experiencing an extreme slowdown in app. Notification will schedule weekly basis. Default is OFF (monthly).'),
                  value: GetStorage().read(kStoredNotificationLimit),
                  onChanged: (value) {
                    setState(() {
                      GetStorage().write(kStoredNotificationLimit, value);
                    });
                  }),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Force rescheduling notification...'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text(
                          'By default, notification will not rescheduled if the last scheduler ran is less than two days.\n\nTap proceed to start an immediate notification scheduling. The app will be restarted.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            GetStorage().write(kForceUpdateNotif, true);
                            Get.forceAppUpdate();
                            CustomNavigatorPop.popTo(context, 3);
                          },
                          child: const Text('Proceed'),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
