import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../constants.dart';
import '../../features/kompas_kiblat/views/qibla_disclaimer_page.dart';
import '../../features/kompas_kiblat/views/qibla_page.dart';
import '../../features/monthly_timetable/views/monthly_timetable_page.dart';
import '../../features/tasbih/views/tasbih_page.dart';
import '../../l10n/app_localizations.dart';

/// This class handles the registration of quick actions
class QuickActionRegistrar {
  /// Register quick actions for the app. Call this method in the main app widget.
  static void registerQuickActions(BuildContext context) {
    const QuickActions quickActions = QuickActions();
    quickActions.initialize((shortcutType) {
      switch (shortcutType) {
        case 'action_qibla':
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'Qibla'),
              builder: (_) => GetStorage().read(kHasShowQiblaWarning)
                  ? const QiblaPage()
                  : const QiblaDisclaimerPage(),
            ),
          );
          break;
        case 'action_tasbih':
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'Tasbih'),
              builder: (_) => const TasbihPage(),
            ),
          );
          break;
        case 'action_timetable':
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: const RouteSettings(name: 'Full timetable'),
              builder: (context) => const MonthlyTimetablePage(),
            ),
          );
          break;
        default:
          print('Unknown shortcut type: $shortcutType');
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
          type: 'action_qibla',
          localizedTitle: AppLocalizations.of(context)!.qiblaTitle,
          icon: 'ic_shortcut_kaaba'),
      ShortcutItem(
          type: 'action_timetable',
          localizedTitle: AppLocalizations.of(context)!.menuTimetableTooltip,
          icon: 'ic_shortcut_calendar'),
      const ShortcutItem(
          type: 'action_tasbih',
          localizedTitle: 'Tasbih',
          icon: 'ic_shortcut_tasbih')
    ]);
  }
}
