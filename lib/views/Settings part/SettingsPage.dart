import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../CONSTANTS.dart' as Constants;
import '../../utils/cupertinoSwitchListTile.dart';
import '../Settings%20part/AboutPage.dart';
import '../Settings%20part/settingsProvider.dart';

class SettingsPage extends StatefulWidget {
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0), child: Text('Display')),
              buildTimeFormat(setting),
              SizedBox(height: 5),
              buildShowOtherPrayerTime(setting),
              SizedBox(height: 5),
              buildFontSize(setting),
              Padding(padding: const EdgeInsets.all(8.0), child: Text('More')),
              buildAboutApp(context),
            ],
          );
        },
      ),
    );
  }

  Card buildFontSize(SettingProvider setting) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text('Font size'),
        ),
        subtitle: Slider(
          activeColor: Colors.teal,
          inactiveColor: Colors.teal.withAlpha(40),
          label: setting.prayerFontSize.round().toString(),
          min: 12.0,
          max: 22.0,
          divisions: 5,
          value: setting.prayerFontSize,
          onChanged: (double value) {
            setting.prayerFontSize = value;
          },
        ),
      ),
    );
  }

  Card buildAboutApp(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('About app'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutAppPage(),
            ),
          );
        },
        subtitle: Text('Release Notes, Contribution, Twitter etc.'),
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
            setting.use12hour = is12;
            GetStorage().write(Constants.kStoredTimeIs12, is12);
            setState(() {
              timeFormat = newValue;
            });
          },
          value: timeFormat,
        ),
      ),
    );
  }
}
