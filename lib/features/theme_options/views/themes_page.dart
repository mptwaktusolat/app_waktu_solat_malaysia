import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/theme_controller.dart';
import '../../../shared/components/animated_moon.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({super.key});
  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1090));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.themeTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Builder(
                builder: (context) {
                  final bool isDarkMode =
                      Theme.of(context).brightness == Brightness.dark;
                  if (isDarkMode) {
                    _animationController!.forward();
                  } else {
                    _animationController!.reverse();
                  }
                  return Center(
                    child: AnimatedMoon(
                      animationController: _animationController,
                      width: MediaQuery.of(context).size.width,
                      isDarkMode: isDarkMode,
                    ),
                  );
                },
              ),
            ),
          ),
          const Expanded(child: ThemesOption()),
        ],
      ),
    );
  }
}

class ThemesOption extends StatefulWidget {
  const ThemesOption({super.key});
  @override
  State<ThemesOption> createState() => _ThemesOptionState();
}

class _ThemesOptionState extends State<ThemesOption> {
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
