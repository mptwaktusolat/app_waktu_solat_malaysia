import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../../providers/settingsProvider.dart';
import '../../CONSTANTS.dart' as constants;
import '../../utils/cupertinoSwitchListTile.dart';
import '../../utils/custom_navigator_pop.dart';
import '../Settings%20part/AboutPage.dart';
import '../Settings%20part/NotificationSettingPage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Consumer<SettingProvider>(
        builder: (context, setting, child) {
          return ListView(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            children: [
              const Padding(
                  padding: EdgeInsets.all(8.0), child: Text('Display')),
              buildTimeFormat(setting),
              const SizedBox(height: 3),
              buildShowOtherPrayerTime(setting),
              const SizedBox(height: 3),
              buildFontSizeSetting(setting),
              const Padding(
                  padding: EdgeInsets.all(8.0), child: Text('Notification')),
              buildNotificationSetting(context),
              const Padding(
                  padding: EdgeInsets.all(8.0), child: Text('Sharing')),
              buildSharingSetting(setting),
              const Padding(padding: EdgeInsets.all(8.0), child: Text('More')),
              buildAboutApp(context),
              const SizedBox(height: 3),
              setting.isDeveloperOption!
                  ? buildVerboseDebugMode(context)
                  : const SizedBox.shrink(),
              const SizedBox(height: 3),
              setting.isDeveloperOption!
                  ? buildResetAllSetting(context)
                  : const SizedBox.shrink(),
              const SizedBox(height: 40)
            ],
          );
        },
      ),
    );
  }

  Card buildFontSizeSetting(SettingProvider setting) {
    return Card(
      child: ListTile(
        title: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Font size'),
        ),
        subtitle: Slider(
          activeColor: CupertinoColors.activeBlue,
          // inactiveColor: Colors.teal.withAlpha(40),
          label: setting.prayerFontSize!.round().toString(),
          min: 12.0,
          max: 22.0,
          divisions: 5,
          value: setting.prayerFontSize!,
          onChanged: (double value) {
            setting.prayerFontSize = value;
          },
        ),
      ),
    );
  }

  Card buildSharingSetting(SettingProvider setting) {
    return Card(
      child: ListTile(
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 2.0),
          child: Text(
            'Specify the default behavior',
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: CupertinoSlidingSegmentedControl(
            groupValue: setting.sharingFormat,
            onValueChanged: (dynamic value) => setting.sharingFormat = value,
            children: const {
              //defaulted to always ask
              0: Text('Always ask'),
              1: Text('Plain Text'),
              2: Text('WhatsApp'),
              3: Text('Copy')
            },
          ),
        ),
      ),
    );
  }

  Card buildVerboseDebugMode(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Verbose debug mode'),
        subtitle: const Text('For developer purposes'),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(GetStorage().read(constants.kIsDebugMode)
                    ? 'Verbose debug mode is ON'
                    : 'Verbose debug mode is OFF'),
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 1.0),
                content: const Text(
                    'Toast message or similar will show throughout usage of the app'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text('Cancel')),
                  TextButton(
                    onPressed: () {
                      //inverse if false then become true & vice versa
                      GetStorage().write(constants.kIsDebugMode,
                          !GetStorage().read(constants.kIsDebugMode));
                      CustomNavigatorPop.popTo(context, 2);
                    },
                    child: GetStorage().read(constants.kIsDebugMode)
                        ? const Text('Turn off')
                        : const Text(
                            'Turn on',
                            style: TextStyle(color: Colors.red),
                          ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }

  Card buildResetAllSetting(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Reset all setting'),
        subtitle: const Text('Deletes all GetStorage() items'),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding:
                    const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 1.0),
                content:
                    const Text('Proceed? The app will exit automatically.'),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () => GetStorage().erase().then((value) => {
                            Fluttertoast.showToast(msg: 'Reset done'),
                            SystemNavigator.pop()
                          }),
                      child: const Text(
                        'Yes. Reset all',
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
      child: FutureBuilder(
        future: PackageInfo.fromPlatform(),
        builder: (_, AsyncSnapshot<PackageInfo> snapshot) {
          if (snapshot.hasData) {
            return ListTile(
              title: Text('About app (Ver. ${snapshot.data!.version})'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AboutAppPage(packageInfo: snapshot.data),
                  ),
                );
              },
              subtitle: const Text('Release Notes, Contribution, Twitter etc.'),
            );
          } else {
            return const ListTile(
              leading: SizedBox(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Card buildNotificationSetting(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Notification settings'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  const NotificationPageSetting(),
            ),
          );
        },
      ),
    );
  }

  Card buildShowOtherPrayerTime(SettingProvider setting) {
    return Card(
      child: CupertinoSwitchListTile(
        activeColor: CupertinoColors.activeBlue,
        title: const Text('Show other prayer times'),
        subtitle: const Text('Imsak, Syuruk, Dhuha'),
        onChanged: (bool value) {
          setting.showOtherPrayerTime = value;
        },
        value: setting.showOtherPrayerTime!,
      ),
    );
  }

  Card buildTimeFormat(SettingProvider setting) {
    return Card(
      child: ListTile(
        title: const Text('Time format'),
        trailing: DropdownButton(
          icon: const Padding(
            padding: EdgeInsets.all(4.0),
            child: FaIcon(FontAwesomeIcons.caretDown, size: 13),
          ),
          items: <String>['12 hour', '24 hour']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) =>
              setting.use12hour = (newValue == '12 hour'),
          value: setting.use12hour! ? '12 hour' : '24 hour',
        ),
      ),
    );
  }
}
