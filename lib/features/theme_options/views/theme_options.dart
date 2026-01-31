import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/theme_controller.dart';

class ThemeOptions extends StatefulWidget {
  const ThemeOptions({super.key});
  @override
  State<ThemeOptions> createState() => _ThemeOptionsState();
}

class _ThemeOptionsState extends State<ThemeOptions> {
  @override
  Widget build(BuildContext context) {
    final Map<String, ThemeMode> themeOptions = {
      AppLocalizations.of(context)!.themeOptionSystem: ThemeMode.system,
      AppLocalizations.of(context)!.themeOptionLight: ThemeMode.light,
      AppLocalizations.of(context)!.themeOptionDark: ThemeMode.dark
    };
    return Consumer<ThemeProvider>(
      builder: (_, setting, __) {
        return RadioGroup(
          onChanged: (dynamic value) {
            setting.themeMode = value;
          },
          groupValue: setting.themeMode,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var theme in themeOptions.entries)
                RadioListTile(
                  title: Text(theme.key),
                  subtitle: theme.value == ThemeMode.system
                      ? Text(AppLocalizations.of(context)!.themeSupportedDevice)
                      : null,
                  value: theme.value,
                )
            ],
          ),
        );
      },
    );
  }
}
