import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../CONSTANTS.dart';
import '../providers/updater_provider.dart';
import '../utils/launch_url.dart';
import 'Qibla%20part/qibla.dart';
import 'Qibla%20part/qibla_warn.dart';
import 'Settings%20part/SettingsPage.dart';
import 'Settings part/theme_page.dart';
import 'ads_widget.dart';
import 'feedback_page.dart';
import 'prayer_full_table.dart';
import 'tasbih.dart';
import 'update_page.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var iconColour = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade600
        : Colors.white60;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AdsWidget(),
        BottomAppBar(
          elevation: 18.0,
          shape: const CircularNotchedRectangle(),
          child: Row(
            children: [
              Consumer<UpdaterProvider>(builder: (_, setting, __) {
                return IconButton(
                    tooltip: AppLocalizations.of(context)?.menuTooltip,
                    icon: Stack(children: [
                      const Align(
                          alignment: Alignment.center,
                          child: FaIcon(FontAwesomeIcons.bars)),
                      setting.needForUpdate
                          ? Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                                width: 8,
                                height: 8,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ]),
                    color: iconColour,
                    onPressed: () {
                      menuModalBottomSheet(context);
                    });
              }),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.calendarDays),
                tooltip: AppLocalizations.of(context)!.menuTimetableTooltip,
                color: iconColour,
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      settings:
                          const RouteSettings(name: 'Full Prayer Timetable'),
                      builder: (_) => PrayerFullTable()));
                },
              ),
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.kaaba),
                color: iconColour,
                tooltip: AppLocalizations.of(context)?.qiblaTitle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: const RouteSettings(name: 'Qibla'),
                      builder: (_) => GetStorage().read(kHasShowQiblaWarning)
                          ? const Qibla()
                          : const QiblaWarn(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: SvgPicture.asset('assets/icons/tasbih-plain.svg',
                    color: iconColour),
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
          ),
        ),
      ],
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
              leading: const FaIcon(FontAwesomeIcons.palette),
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
              leading: const FaIcon(FontAwesomeIcons.gear),
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
                  title: Stack(children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        width: 8,
                        height: 8,
                      ),
                    ),
                    Text(AppLocalizations.of(context)!.menuUpdateAvailable)
                  ]),
                  leading: const FaIcon(FontAwesomeIcons.googlePlay),
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
                  leading: const FaIcon(FontAwesomeIcons.solidStar),
                  trailing:
                      const FaIcon(FontAwesomeIcons.squareUpRight, size: 21),
                  onTap: () {
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: '⭐⭐⭐⭐⭐',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey.shade700,
                    );
                    LaunchUrl.normalLaunchUrl(url: kPlayStoreListingLink);
                  },
                );
              }
            }),
            ListTile(
              title: Text(AppLocalizations.of(context)!.menuWeb),
              leading: const FaIcon(FontAwesomeIcons.chrome),
              trailing: const FaIcon(FontAwesomeIcons.squareUpRight, size: 21),
              onTap: () {
                Navigator.pop(context);
                LaunchUrl.normalLaunchUrl(url: kWebappUrl);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.menuFeedback),
              leading: const FaIcon(FontAwesomeIcons.solidCommentDots),
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
