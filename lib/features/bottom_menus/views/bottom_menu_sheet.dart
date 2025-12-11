import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../providers/updater_provider.dart';
import '../../../shared/constants/env.dart';
import '../../../shared/utils/launch_url.dart';
import '../../../views/settings/settings_page.dart';
import '../../../views/settings/theme_page.dart';
import '../../check_updates/views/update_page.dart';
import '../../feedback/views/feedback_page.dart';

/// The bottom menu sheet that appears when the menu button is pressed
class BottomMenuSheet extends StatelessWidget {
  const BottomMenuSheet({super.key});

  /// Opens the feedback dialog
  void _openFeedbackDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: 'Feedback Page'),
        builder: (_) => const FeedbackPage(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
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
                      builder: (_) => const ThemesPage()),
                );
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
                _openFeedbackDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
