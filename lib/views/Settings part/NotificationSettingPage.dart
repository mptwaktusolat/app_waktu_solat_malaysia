import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../CONSTANTS.dart';
import '../../utils/cupertinoSwitchListTile.dart';
import '../../utils/navigator_pop.dart';

class NotificationPageSetting extends StatefulWidget {
  const NotificationPageSetting({Key key}) : super(key: key);
  @override
  _NotificationPageSettingState createState() =>
      _NotificationPageSettingState();
}

class _NotificationPageSettingState extends State<NotificationPageSetting> {
  var prayerNotification = [true, true, true, true, true, true, true];
  bool isAnythingChanged = false; //effect the button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        centerTitle: true,
        // actions: [
        //   FlatButton(
        //     shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
        //     textColor: Colors.white,
        //     onPressed: !isAnythingChanged
        //         ? null
        //         : () {
        //             print('Save button clicked');
        //             print(prayerNotification);
        //             Navigator.pop(context);
        //           },
        //     child: Text(
        //       'SAVE',
        //     ),
        //   )
        // ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          //Turned of for a while
          // Text('Basic'),
          // Card(
          //   child: Column(children: [
          //     CupertinoSwitchListTile(
          //         title: Text(PrayerName.prayerName[0]),
          //         value: prayerNotification[0],
          //         onChanged: (bool value) {
          //           setState(() {
          //             isAnythingChanged = true;
          //             prayerNotification[0] = value;
          //           });
          //         }),
          //     CupertinoSwitchListTile(
          //         title: Text(PrayerName.prayerName[1]),
          //         value: prayerNotification[1],
          //         onChanged: (bool value) {
          //           setState(() {
          //             isAnythingChanged = true;
          //             prayerNotification[1] = value;
          //           });
          //         }),
          //     CupertinoSwitchListTile(
          //         title: Text(PrayerName.prayerName[2]),
          //         value: prayerNotification[2],
          //         onChanged: (bool value) {
          //           setState(() {
          //             isAnythingChanged = true;
          //             prayerNotification[2] = value;
          //           });
          //         }),
          //     CupertinoSwitchListTile(
          //         title: Text(PrayerName.prayerName[3]),
          //         value: prayerNotification[3],
          //         onChanged: (bool value) {
          //           setState(() {
          //             isAnythingChanged = true;
          //             prayerNotification[3] = value;
          //           });
          //         }),
          //     CupertinoSwitchListTile(
          //         title: Text(PrayerName.prayerName[4]),
          //         value: prayerNotification[4],
          //         onChanged: (bool value) {
          //           setState(() {
          //             isAnythingChanged = true;
          //             prayerNotification[4] = value;
          //           });
          //         }),
          //     CupertinoSwitchListTile(
          //         title: Text(PrayerName.prayerName[5]),
          //         value: prayerNotification[5],
          //         onChanged: (bool value) {
          //           setState(() {
          //             isAnythingChanged = true;
          //             prayerNotification[5] = value;
          //           });
          //         }),
          //   ]),
          // ),
          const Padding(padding: EdgeInsets.all(8.0), child: Text('Basic')),
          Card(
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: const Text('App notification System Setting'),
              subtitle: const Text(
                  'Customize sound, toggle channel of prayer notification etc.'),
              trailing: const Icon(Icons.launch_rounded),
              onTap: () async {
                await AppSettings.openNotificationSettings();
              },
            ),
          ),
          const Padding(
              padding: EdgeInsets.all(8.0), child: Text('Troubleshooting')),

          Card(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CupertinoSwitchListTile(
                  title: const Text('Limit notification scheduling'),
                  subtitle: const Text(
                      'Enable if you experiencing an extreme slowdown in app. Notification will schedule weekly basis. Default is OFF (monthly).'),
                  value: GetStorage().read(kStoredNotificationLimit),
                  onChanged: (value) {
                    // print(value);
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
                              print(GetStorage().read(kForceUpdateNotif));
                              Get.forceAppUpdate();
                              CustomNavigatorPop.popTo(context, 3);
                            },
                            child: const Text('Proceed'),
                          )
                        ],
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
