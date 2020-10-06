import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            child: Text('Image here'),
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
  ThemeMode _themeMode = ThemeMode.light;
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      RadioListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Light Theme'),
          ),
          value: ThemeMode.light,
          groupValue: _themeMode,
          onChanged: (value) {
            setState(() {
              _themeMode = value;
              Get.changeThemeMode(_themeMode);
            });
          }),
      RadioListTile(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Dark Theme'),
          ),
          value: ThemeMode.dark,
          groupValue: _themeMode,
          onChanged: (value) {
            setState(() {
              _themeMode = value;
              Get.changeThemeMode(_themeMode);
            });
          }),
    ]);
  }
}
