import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../CONSTANTS.dart';
import '../Settings%20part/ThemeController.dart';

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
  Map<String, ThemeMode> _themeOptions = {
    'System Theme': ThemeMode.system,
    'Light Theme': ThemeMode.light,
    'Dark Theme': ThemeMode.dark
  };
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, setting, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _themeOptions.length,
          itemBuilder: (context, index) {
            return RadioListTile(
                title: Text(_themeOptions.keys.elementAt(index)),
                subtitle: index == 0 ? Text('On supported device only') : null,
                value: _themeOptions.values.elementAt(index),
                groupValue: setting.themeMode,
                onChanged: (value) {
                  setting.themeMode = value;
                });
          },
        );
      },
    );
  }
}
