import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../CONSTANTS.dart';
import '../utils/AppInformation.dart';
import '../utils/copyAndShare.dart';
import '../utils/launchUrl.dart';
import 'Settings%20part/SettingsPage.dart';
import 'Settings%20part/ThemePage.dart';
import 'feedbackPage.dart';

AppInfo info = AppInfo();

class MyBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String init = info.appName; //just to init the class
    var iconColour = Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade600
        : Colors.white60;
    return BottomAppBar(
      elevation: 18.0,
      shape: CircularNotchedRectangle(),
      child: Row(
        children: [
          IconButton(
              tooltip: 'Open menu',
              icon: FaIcon(FontAwesomeIcons.bars),
              color: iconColour,
              onPressed: () {
                menuModalBottomSheet(context);
              }),
          IconButton(
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
            icon: FaIcon(FontAwesomeIcons.kaaba),
            color: iconColour,
            tooltip: 'Kibla compass',
            onPressed: () {
              print('opening page kaaba');
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
              title: Text('Themes'),
              leading: FaIcon(FontAwesomeIcons.palette),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ThemesPage()));
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: FaIcon(FontAwesomeIcons.cog),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsPage(
                              info: info,
                            )));
              },
            ),
            Divider(
              thickness: 1,
              height: 0.0,
            ),
            ListTile(
              title: Text('Rate and review'),
              leading: FaIcon(FontAwesomeIcons.solidStar),
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
