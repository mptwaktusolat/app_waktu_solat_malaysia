import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waktusolatmalaysia/views/full_prayer_table.dart';
import '../CONSTANTS.dart';
import '../utils/copyAndShare.dart';
import '../utils/launchUrl.dart';
import 'Settings%20part/SettingsPage.dart';
import 'Settings%20part/ThemePage.dart';
import 'feedbackPage.dart';

class MyBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var iconColour = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade600
        : Colors.white60;
    return BottomAppBar(
      elevation: 18.0,
      shape: CircularNotchedRectangle(),
      child: Row(
        children: [
          IconButton(
              iconSize: 18,
              tooltip: 'Open menu',
              icon: FaIcon(FontAwesomeIcons.bars),
              color: iconColour,
              onPressed: () {
                menuModalBottomSheet(context);
              }),
          IconButton(
            iconSize: 18,
            icon: FaIcon(FontAwesomeIcons.clone),
            tooltip: 'Copy timetable',
            color: iconColour,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: CopyAndShare.getMessage()))
                  .then(
                (value) {
                  Fluttertoast.showToast(msg: 'Timetable copied');
                },
              );
            },
          ),
          IconButton(
            iconSize: 18,
            icon: FaIcon(FontAwesomeIcons.kaaba),
            color: iconColour,
            tooltip: 'Google QiblaFinder',
            onPressed: () {
              LaunchUrl.normalLaunchUrl(url: 'https://g.co/qiblafinder');
            },
          ),
          IconButton(
            iconSize: 18,
            icon: FaIcon(FontAwesomeIcons.calendarAlt),
            color: iconColour,
            tooltip: 'Full Prayer Timetable',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => FullPrayerTable()));
            },
          ),
          IconButton(
              iconSize: 18,
              color: iconColour,
              tooltip: 'Themes',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ThemesPage()));
              },
              icon: FaIcon(FontAwesomeIcons.palette))
        ],
      ),
    );
  }
}

void menuModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.0),
          child: Wrap(children: <Widget>[
            ListTile(
              title: Text('Settings'),
              leading: FaIcon(FontAwesomeIcons.cog),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
            Divider(
              thickness: 1,
              height: 0.0,
            ),
            ListTile(
              title: Text('Get app for Android'),
              leading: FaIcon(FontAwesomeIcons.googlePlay),
              onTap: () {
                Navigator.pop(context);
                LaunchUrl.normalLaunchUrl(url: kPlayStoreListingLink);
              },
            ),
            ListTile(
              title: Text('Send feedback'),
              leading: FaIcon(FontAwesomeIcons.solidCommentDots),
              onTap: () {
                Navigator.pop(context);
                print('Opening feedback dialog');
                openFeedbackDialog(context);
              },
            ),
          ]),
        );
      });
}

void openFeedbackDialog(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (BuildContext context) {
          return FeedbackPage();
        },
        fullscreenDialog: true),
  );
}
