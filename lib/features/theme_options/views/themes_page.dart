import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/components/animated_moon.dart';
import '../../../shared/constants/constants.dart';
import 'theme_options.dart';

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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (isDarkMode) {
      _animationController!.forward();
    } else {
      _animationController!.reverse();
    }

    final moonWidget = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedMoon(
              animationController: _animationController,
              width: constraints.maxWidth,
              isDarkMode: isDarkMode,
            );
          },
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.themeTitle),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= kTabletBreakpoint) {
            // Tablet layout
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: moonWidget,
                  ),
                ),
                const Expanded(child: ThemeOptions()),
              ],
            );
          }
          // Phone layout
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: moonWidget,
                ),
              ),
              const Expanded(child: ThemeOptions()),
            ],
          );
        },
      ),
    );
  }
}
