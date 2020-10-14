import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart' as Constants;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String timeFormatValue;

  @override
  void initState() {
    super.initState();
    timeFormatValue =
        '${GetStorage().read(Constants.kStoredTimeFormatValue) ?? "12-hour"}';
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
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
                    setState(() {
                      timeFormatValue = newValue;
                    });
                  },
                  value: timeFormatValue,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              child: ListTile(
                title: Text('About app'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
