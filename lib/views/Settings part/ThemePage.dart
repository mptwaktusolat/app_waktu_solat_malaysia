import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/ThemeController.dart';

class ThemesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: CachedNetworkImage(
                imageUrl: kThemeUiUrl,
              ),
            ),
          ),
          Expanded(child: ThemesOption()),
        ],
      ),
    );
  }
}

class ThemesOption extends StatefulWidget {
  @override
  _ThemesOptionState createState() => _ThemesOptionState();
}

class _ThemesOptionState extends State<ThemesOption> {
  ThemeMode _themeMode;
  @override
  Widget build(BuildContext context) {
    _themeMode = ThemeController.to.themeMode;
    return ListView(children: [
      RadioListTile(
          title: Text('System Theme'),
          subtitle: Text('On supported device only'),
          value: ThemeMode.system,
          groupValue: _themeMode,
          onChanged: (value) {
            setState(() {
              _themeMode = value;
              ThemeController.to.setThemeMode(_themeMode);
            });
          }),
      RadioListTile(
          title: Text('Light Theme'),
          value: ThemeMode.light,
          groupValue: _themeMode,
          onChanged: (value) {
            setState(() {
              _themeMode = value;
              ThemeController.to.setThemeMode(_themeMode);
            });
          }),
      RadioListTile(
          title: Text('Dark Theme'),
          value: ThemeMode.dark,
          groupValue: _themeMode,
          onChanged: (value) {
            setState(() {
              _themeMode = value;
              ThemeController.to.setThemeMode(_themeMode);
            });
          }),
    ]);
  }
}
