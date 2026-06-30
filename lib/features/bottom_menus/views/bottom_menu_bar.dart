import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotspot/hotspot.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/updater_provider.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/utils/my_mpt_icons_icons.dart';
import '../../kompas_kiblat/views/qibla_disclaimer_page.dart';
import '../../kompas_kiblat/views/qibla_page.dart';
import '../../monthly_timetable/views/monthly_timetable_page.dart';
import '../../tasbih/views/tasbih_page.dart';
import 'bottom_menu_sheet.dart';

/// The bottom menu bar that appears at the bottom of the home page and houses
/// several utility menus
class BottomMenuBar extends StatelessWidget {
  const BottomMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          // Set theme icon for the whole icon widget for this component
          iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onPrimaryContainer)),
      child: BottomAppBar(
        color: Theme.of(context).colorScheme.primaryContainer.withAlpha(100),
        child: Row(
          children: [
            Consumer<UpdaterProvider>(builder: (_, setting, __) {
              return IconButton(
                tooltip: AppLocalizations.of(context)?.menuTooltip,
                icon: setting.needForUpdate
                    ? Badge(
                        offset: Offset(5, -5),
                        label: FaIcon(
                          FontAwesomeIcons.download,
                          size: 8,
                          color: Theme.of(context).colorScheme.onError,
                        ),
                        child: FaIcon(FontAwesomeIcons.bars),
                      )
                    : FaIcon(FontAwesomeIcons.bars),
                onPressed: () => _showMenuModalBottomSheet(context),
              ).withHotspot(
                order: 3,
                title: AppLocalizations.of(context)!
                    .onboardingCoachmarkSettingTitle,
                text: AppLocalizations.of(context)!
                    .onboardingCoachmarkSettingContent,
                flow: kOnboardingCoachmarkFlow,
              );
            }),
            // These buttons were grouped into Row because we want to combine
            // the coachmark
            Row(
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.calendarDays),
                  tooltip: AppLocalizations.of(context)!.menuTimetableTooltip,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        settings:
                            const RouteSettings(name: 'Full Prayer Timetable'),
                        builder: (_) => const MonthlyTimetablePage(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.kaaba),
                  tooltip: AppLocalizations.of(context)?.qiblaTitle,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'Qibla'),
                        builder: (_) => GetStorage().read(kHasShowQiblaWarning)
                            ? const QiblaPage()
                            : const QiblaDisclaimerPage(),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(MyMptIcons.tasbih_plain),
                  tooltip: "Tasbih",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(name: 'Tasbih'),
                        builder: (_) => const TasbihPage(),
                      ),
                    );
                  },
                )
              ],
            ).withHotspot(
              order: 2,
              title: AppLocalizations.of(context)!
                  .onboardingCoachmarkUtilitiesTitle,
              text: AppLocalizations.of(context)!
                  .onboardingCoachmarkUtilitiesContent,
              flow: kOnboardingCoachmarkFlow,
            ),
          ],
        ),
      ),
    );
  }

  /// Opens the bottom menu modal sheet
  void _showMenuModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => const BottomMenuSheet(),
    );
  }
}
