import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'prayer_full_table.dart';
import '../CONSTANTS.dart';
import '../utils/launchUrl.dart';
import 'Qibla%20part/qibla.dart';
import 'Settings%20part/SettingsPage.dart';
import 'Settings%20part/ThemePage.dart';
import 'feedbackPage.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var iconColour = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade600
        : Colors.white60;
    return BottomAppBar(
      elevation: 18.0,
      shape: const CircularNotchedRectangle(),
      child: Row(
        children: [
          IconButton(
              tooltip: 'Open menu',
              icon: const FaIcon(FontAwesomeIcons.bars),
              color: iconColour,
              onPressed: () {
                menuModalBottomSheet(context);
              }),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.calendarAlt),
            tooltip: 'Full timetable',
            color: iconColour,
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => PrayerFullTable()));
            },
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.kaaba),
            color: iconColour,
            tooltip: 'Kibla compass',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Qibla()));
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
              title: const Text('Themes'),
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
              title: const Text('Settings'),
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
            ListTile(
              title: const Text('Rate and review'),
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
            ),
            ListTile(
              title: const Text('MPT on web'),
              leading: const FaIcon(FontAwesomeIcons.chrome),
              trailing: const FaIcon(FontAwesomeIcons.externalLinkSquareAlt,
                  size: 21),
              onTap: () {
                Navigator.pop(context);
                LaunchUrl.normalLaunchUrl(url: kWebappUrl);
              },
            ),
            ListTile(
              title: const Text('Send feedback'),
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
