import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:waktusolatmalaysia/utils/navigator_pop.dart';

import '../../CONSTANTS.dart' as Constants;
import '../../utils/AppInformation.dart';
import '../../utils/cupertinoSwitchListTile.dart';
import '../Settings%20part/AboutPage.dart';
import '../Settings%20part/NotificationSettingPage.dart';
import '../Settings%20part/settingsProvider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.info});
  final AppInfo info;
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String timeFormat;

  @override
  void initState() {
    super.initState();
    timeFormat =
        GetStorage().read(Constants.kStoredTimeIs12) ? '12 hour' : '24 hour';
    print(timeFormat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Consumer<SettingProvider>(
        builder: (context, setting, child) {
          return ListView(
            // physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('Display')),
              buildTimeFormat(setting),
              SizedBox(height: 5),
              buildShowOtherPrayerTime(setting),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Notification')),
              buildNotificationSetting(context),
              Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('Sharing')),
              Card(
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
                    child: Text(
                      'Specify the text format generated for sharing',
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CupertinoSlidingSegmentedControl(
                      groupValue: setting.sharingFormat,
                      onValueChanged: (value) => setting.sharingFormat = value,
                      children: {
                        //defaulted to always ask
                        0: Text('Always ask'),
                        1: Text('Plain Text'),
                        2: Text('WhatsApp'),
                      },
                    ),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(8.0), child: Text('More')),
              // SizedBox(height: 5),
              buildAboutApp(context),
              setting.isDeveloperOption
                  ? buildVerboseDebugMode(context)
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  Card buildVerboseDebugMode(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Verbose debug mode'),
        subtitle: Text('For developer purposes'),
        onTap: () {
          print('VERBOSE DEBUG MODE');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(GetStorage().read(Constants.kIsDebugMode)
                    ? 'Verbose debug mode is ON'
                    : 'Verbose debug mode is OFF'),
                content: Text(
                    'Toast message or similar will show throughout usage of the app'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        print('PROCEED');
                        //inverse if false then become true & vice versa
                        GetStorage().write(Constants.kIsDebugMode,
                            !GetStorage().read(Constants.kIsDebugMode));
                        CustomNavigatorPop.popTo(context, 2);
                      },
                      child: GetStorage().read(Constants.kIsDebugMode)
                          ? Text('Turn off')
                          : Text(
                              'Turn on',
                              style: TextStyle(color: Colors.red),
                            ))
                ],
              );
            },
          );
        },
      ),
    );
  }

  Card buildAboutApp(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('About app (Ver. ${widget.info.version})'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutAppPage(widget.info),
            ),
          );
        },
        subtitle: Text('Release Notes, Contribution, Twitter etc.'),
      ),
    );
  }

  Card buildNotificationSetting(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Notification settings'),
        onTap: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => NotificationPageSetting(),
            ),
          );
        },
      ),
    );
  }

  Card buildShowOtherPrayerTime(SettingProvider setting) {
    return Card(
      child: CupertinoSwitchListTile(
        title: Text('Show other prayer times'),
        subtitle: Text('Imsak, Syuruk, Dhuha'),
        onChanged: (bool value) {
          setState(() {
            setting.showOtherPrayerTime = value;
            GetStorage().write(Constants.kStoredShowOtherPrayerTime, value);
          });
        },
        value: setting.showOtherPrayerTime,
      ),
    );
  }

  Card buildTimeFormat(SettingProvider setting) {
    return Card(
      child: ListTile(
        title: Text('Time format'),
        trailing: DropdownButton(
          items: <String>['12 hour', '24 hour']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String newValue) {
            var is12 = newValue == '12 hour';
            // print('NewValue $newValue');
            setting.use12hour = is12;
            GetStorage().write(Constants.kStoredTimeIs12, is12);
            setState(() {
              timeFormat = newValue;
              print(GetStorage().read(Constants.kStoredTimeIs12));
            });
          },
          value: timeFormat,
        ),
      ),
    );
  }
}
