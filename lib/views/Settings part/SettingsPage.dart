import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart' as Constants;
import 'package:waktusolatmalaysia/utils/AppInformation.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/AboutPage.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/settingsProvider.dart';

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
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Card(
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
                ),
                SizedBox(
                  height: 5,
                ),
                Card(
                  child: ListTile(
                    title: Text('About app (Ver. ${widget.info.version})'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutAppPage(widget.info)));
                    },
                    subtitle: Text(
                        'Privacy Policy, Release Notes, Contribution etc.'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
