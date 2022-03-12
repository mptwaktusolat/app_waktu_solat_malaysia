import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../CONSTANTS.dart';
import '../providers/updater_provider.dart';
import '../utils/launchUrl.dart';
import 'Qibla%20part/qibla.dart';
import 'Qibla%20part/qibla_warn.dart';
import 'Settings%20part/SettingsPage.dart';
import 'Settings%20part/ThemePage.dart';
import 'feedbackPage.dart';
import 'prayer_full_table.dart';
import 'tasbih.dart';
import 'update_page.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var _iconColour = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade600
        : Colors.white60;
    return BottomAppBar(
      elevation: 18.0,
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: [
          Consumer<UpdaterProvider>(builder: (_, setting, __) {
            return IconButton(
                tooltip: AppLocalizations.of(context)?.menuThemes,
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
                color: _iconColour,
                onPressed: () {
                  menuModalBottomSheet(context);
                });
          }),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.calendarAlt),
            tooltip: AppLocalizations.of(context)!.menuTimetableTooltip,
            color: _iconColour,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => PrayerFullTable()));
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.kaaba),
            color: _iconColour,
            tooltip: AppLocalizations.of(context)?.menuKiblaCompassTooltip,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GetStorage().read(kHasShowQiblaWarning)
                      ? const Qibla()
                      : const QiblaWarn(),
                ),
              );
            },
          ),
          IconButton(
            icon: Image.asset('assets/icons/tasbih-Custom.png',
                color: Theme.of(context).iconTheme.color),
            color: _iconColour,
            tooltip: "Tasbih for Zikr",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Tasbih(),
                ),
              );
            },
          )
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
              leading: const FaIcon(FontAwesomeIcons.palette),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ThemesPage()));
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.menuSettings),
              leading: const FaIcon(FontAwesomeIcons.cog),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
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
                  trailing: const FaIcon(FontAwesomeIcons.externalLinkSquareAlt,
                      size: 21),
                  onTap: () {
                    Navigator.pop(context);
                    setting.needForUpdate = false;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const UpdatePage(),
                        ));
                  },
                );
              } else {
                return ListTile(
                  title: Text(AppLocalizations.of(context)!.menuRate),
                  leading: const FaIcon(FontAwesomeIcons.solidStar),
                  trailing: const FaIcon(FontAwesomeIcons.externalLinkSquareAlt,
                      size: 21),
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
              trailing: const FaIcon(FontAwesomeIcons.externalLinkSquareAlt,
                  size: 21),
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
        builder: (BuildContext context) {
          return const FeedbackPage();
        },
        fullscreenDialog: true),
  );
}
