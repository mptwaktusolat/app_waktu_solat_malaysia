import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/utils/copyAndShare.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/SettingsPage.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/ThemePage.dart';
import 'package:waktusolatmalaysia/views/feedbackPage.dart';
import '../utils/AppInformation.dart';

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
              icon: Icon(Icons.menu),
              color: iconColour,
              onPressed: () {
                menuModalBottomSheet(context);
              }),
          IconButton(
              icon: Icon(
                Icons.color_lens,
                color: iconColour,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ThemesPage()));
              }),
          IconButton(
              icon: Icon(Icons.copy),
              tooltip: 'Copy timetable',
              color: iconColour,
              onPressed: () {
                Clipboard.setData(
                        ClipboardData(text: CopyAndShare.getMessage()))
                    .then((value) {
                  Fluttertoast.showToast(msg: 'Timetable copied');
                });
              })
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
              leading: Icon(Icons.color_lens),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ThemesPage()));
              },
            ),
            ListTile(
              title: Text('Settings'),
              leading: Icon(Icons.settings),
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
            ListTile(
              title: Text('Rate and review'),
              leading: Icon(Icons.star),
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
            Divider(
              thickness: 1,
              height: 0.0,
            ),
            ListTile(
              title: Text('Send feedback'),
              leading: Icon(Icons.feedback),
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
