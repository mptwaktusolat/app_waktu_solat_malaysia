// at the moment, this feature is not readily implemented
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
  bool isAnythingChanged = false; //effect the button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
        centerTitle: true,
        actions: [
          FlatButton(
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            textColor: Colors.white,
            onPressed: !isAnythingChanged
                ? null
                : () {
                    print('Save button clicked');
                    print(prayerNotification);
                    Navigator.pop(context);
                  },
            child: Text(
              'SAVE',
            ),
          )
        ],
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
                    setState(() {
                      isAnythingChanged = true;
                      prayerNotification[0] = value;
                    });
                  }),
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[1]),
                  value: prayerNotification[1],
                  onChanged: (bool value) {
                    setState(() {
                      isAnythingChanged = true;
                      prayerNotification[1] = value;
                    });
                  }),
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[2]),
                  value: prayerNotification[2],
                  onChanged: (bool value) {
                    setState(() {
                      isAnythingChanged = true;
                      prayerNotification[2] = value;
                    });
                  }),
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[3]),
                  value: prayerNotification[3],
                  onChanged: (bool value) {
                    setState(() {
                      isAnythingChanged = true;
                      prayerNotification[3] = value;
                    });
                  }),
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[4]),
                  value: prayerNotification[4],
                  onChanged: (bool value) {
                    setState(() {
                      isAnythingChanged = true;
                      prayerNotification[4] = value;
                    });
                  }),
              CupertinoSwitchListTile(
                  title: Text(PrayerName.prayerName[5]),
                  value: prayerNotification[5],
                  onChanged: (bool value) {
                    setState(() {
                      isAnythingChanged = true;
                      prayerNotification[5] = value;
                    });
                  }),
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
