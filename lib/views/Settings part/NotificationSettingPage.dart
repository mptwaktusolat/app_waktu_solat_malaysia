import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waktusolatmalaysia/utils/cupertinoSwitchListTile.dart';
import 'package:waktusolatmalaysia/utils/prayerName.dart';

class NotificationPageSetting extends StatefulWidget {
  @override
  _NotificationPageSettingState createState() =>
      _NotificationPageSettingState();
}

class _NotificationPageSettingState extends State<NotificationPageSetting> {
  var prayerNotification = [true, true, true, true, true, true, true];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text('Basic'),
          Card(
            child: Column(children: [
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[0]),
                  value: prayerNotification[0],
                  onChanged: (bool value) {
                    print('huhuuhu');
                  }),
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[1]),
                  value: prayerNotification[0],
                  onChanged: (bool value) {
                    print('huhuuhu');
                  }),
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[2]),
                  value: prayerNotification[0],
                  onChanged: (bool value) {
                    print('huhuuhu');
                  }),
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[3]),
                  value: prayerNotification[0],
                  onChanged: (bool value) {
                    print('huhuuhu');
                  }),
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[4]),
                  value: prayerNotification[0],
                  onChanged: (bool value) {
                    print('huhuuhu');
                  }),

              //TODO:Sambung sini
            ]),
          ),
          Text('Advanced'),
          Card(
              child: ListTile(
            title: Text('App notification System Setting'),
            subtitle:
                Text('Change sound, vibration of prayer notification etc.'),
            trailing: Icon(Icons.launch_rounded),
            onTap: () async {
              await AppSettings.openNotificationSettings();
            },
          ))
        ],
      ),
    );
  }
}
