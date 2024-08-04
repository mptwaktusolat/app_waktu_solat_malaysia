import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hotspot/hotspot.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../env.dart';
import '../features/check_updates/views/update_page.dart';
import '../features/feedback/views/feedback_page.dart';
import '../features/kompas_kiblat/views/qibla_disclaimer_page.dart';
import '../features/kompas_kiblat/views/qibla_page.dart';
import '../providers/updater_provider.dart';
import '../utils/launch_url.dart';
import '../utils/my_mpt_icons_icons.dart';
import 'prayer_full_table.dart';
import 'settings/settings_page.dart';
import 'settings/theme_page.dart';
import 'tasbih.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          Consumer<UpdaterProvider>(builder: (_, setting, __) {
            return IconButton(
              tooltip: AppLocalizations.of(context)?.menuTooltip,
              icon: setting.needForUpdate
                  ? const Badge(
                      smallSize: 12,
                      child: FaIcon(FontAwesomeIcons.bars),
                    )
                  : const FaIcon(FontAwesomeIcons.bars),
              onPressed: () => menuModalBottomSheet(context),
            ).withHotspot(
              order: 3,
              title:
                  AppLocalizations.of(context)!.onboardingCoachmarkSettingTitle,
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
                icon: const FaIcon(FontAwesomeIcons.calendarDays),
                tooltip: AppLocalizations.of(context)!.menuTimetableTooltip,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      settings:
                          const RouteSettings(name: 'Full Prayer Timetable'),
                      builder: (_) => PrayerFullTable()));
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.kaaba),
                // color: iconColour,
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
                icon: const Icon(MyMptIcons.tasbih_plain),
                tooltip: "Tasbih",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(name: 'Tasbih'),
                      builder: (_) => const Tasbih(),
                    ),
                  );
                },
              )
            ],
          ).withHotspot(
            order: 2,
            title:
                AppLocalizations.of(context)!.onboardingCoachmarkUtilitiesTitle,
            text: AppLocalizations.of(context)!
                .onboardingCoachmarkUtilitiesContent,
            flow: kOnboardingCoachmarkFlow,
          ),
        ],
      ),
    );
  }
}

void menuModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(4.0),
        child: Wrap(
          children: <Widget>[
            ListTile(
              title: Text(AppLocalizations.of(context)!.menuThemes),
              leading: FaIcon(FontAwesomeIcons.palette,
                  color: Theme.of(context).colorScheme.secondary),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: const RouteSettings(name: 'Themes'),
                        builder: (_) => const ThemesPage()));
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.menuSettings),
              leading: FaIcon(FontAwesomeIcons.gear,
                  color: Theme.of(context).colorScheme.secondary),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: const RouteSettings(name: 'Settings'),
                    builder: (_) => const SettingsPage(),
                  ),
                );
              },
            ),
            const Divider(
              thickness: 1,
              height: 0.0,
            ),
            Consumer<UpdaterProvider>(builder: (_, setting, __) {
              if (setting.needForUpdate) {
                return ListTile(
                  title: Row(
                    children: [
                      Text(AppLocalizations.of(context)!.menuUpdateAvailable),
                      const SizedBox(width: 5.0),
                      const Badge(smallSize: 8),
                    ],
                  ),
                  leading: FaIcon(FontAwesomeIcons.googlePlay,
                      color: Theme.of(context).colorScheme.secondary),
                  trailing:
                      const FaIcon(FontAwesomeIcons.squareUpRight, size: 21),
                  onTap: () {
                    Navigator.pop(context);
                    setting.needForUpdate = false;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: const RouteSettings(name: 'Update Page'),
                          builder: (_) => const UpdatePage(),
                        ));
                  },
                );
              } else {
                return ListTile(
                  title: Text(AppLocalizations.of(context)!.menuRate),
                  leading: FaIcon(FontAwesomeIcons.solidStar,
                      color: Theme.of(context).colorScheme.secondary),
                  trailing:
                      const FaIcon(FontAwesomeIcons.squareUpRight, size: 21),
                  onTap: () {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: '⭐⭐⭐⭐⭐',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey.shade700,
                    );
                    LaunchUrl.normalLaunchUrl(url: envPlayStoreListingLink);
                  },
                );
              }
            }),
            ListTile(
              title: Text(AppLocalizations.of(context)!.menuWeb),
              leading: FaIcon(FontAwesomeIcons.chrome,
                  color: Theme.of(context).colorScheme.secondary),
              trailing: const FaIcon(FontAwesomeIcons.squareUpRight, size: 21),
              onTap: () {
                Navigator.pop(context);
                LaunchUrl.normalLaunchUrl(url: envWebappUrl);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.menuFeedback),
              leading: FaIcon(FontAwesomeIcons.solidCommentDots,
                  color: Theme.of(context).colorScheme.secondary),
              onTap: () {
                Navigator.pop(context);
                openFeedbackDialog(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

void openFeedbackDialog(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      settings: const RouteSettings(name: 'Feedback Page'),
      builder: (_) => const FeedbackPage(),
      fullscreenDialog: true,
    ),
  );
}
