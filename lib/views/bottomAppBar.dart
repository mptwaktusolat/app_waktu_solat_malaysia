import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/utils/copyAndShare.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/ThemePage.dart';
import 'package:waktusolatmalaysia/views/contributionPage.dart';
import 'package:waktusolatmalaysia/views/feedbackPage.dart';
import '../utils/AppInformation.dart';

AppInfo info = AppInfo();

class MyBottomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String init = info.appName; //just to init the class
    return BottomAppBar(
      elevation: 18.0,
      shape: CircularNotchedRectangle(),
      child: Row(
        children: [
          IconButton(
              tooltip: 'Open menu',
              icon: Icon(Icons.menu),
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade600
                  : Colors.white60,
              onPressed: () {
                menuModalBottomSheet(context);
              }),
          IconButton(
              icon: Icon(Icons.copy),
              tooltip: 'Copy timetable',
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade600
                  : Colors.white60,
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
            ListTile(
              title: Text('Contribution and support'),
              leading: Icon(Icons.support),
              onTap: () {
                Navigator.pop(context);
                print('Opening contribution page');
                openContributionDialog(context);
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
            ListTile(
              title: Text('About app'),
              // subtitle: Text(info.version),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.pop(context);
                myAboutDialog(context);
              },
            ),
          ]),
        );
      });
}

void myAboutDialog(BuildContext context) {
  bool isFirstTry = true;
  return showAboutDialog(
      context: context,
      applicationIcon: GestureDetector(
        onLongPress: () {
          if (isFirstTry) {
            Fluttertoast.showToast(msg: '(⌐■_■)');
            isFirstTry = false;
          } else {
            Fluttertoast.showToast(msg: '(❁´◡`❁)');
            //   print('Show debug dialog');
            //   showDialog(
            //     //TODO: Enable when i made about dialog in full screen
            //     context: context,
            //     builder: (context) => Dialog(
            //       backgroundColor: Colors.white,
            //       child: ListView(
            //         children: [
            //           ListTile(
            //             title: Text('Prayer time API calls'),
            //             subtitle: Text('example link'),
            //           )
            //         ],
            //       ),
            //     ),
            //   );
          }
        },
        child: CachedNetworkImage(
          width: 45,
          imageUrl: kAppIconUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      applicationLegalese: '© 2020 Fareez Iqmal',
      applicationVersion: 'Version ${info.version}',
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Text(
          'Prayer time data provided by JAKIM',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        FlatButton(
            color: Theme.of(context).bottomAppBarColor,
            onPressed: () {
              LaunchUrl.normalLaunchUrl(url: kPrivacyPolicyLink);
            },
            child: Text('Privacy Policy')),
        FlatButton(
          color: Theme.of(context).bottomAppBarColor,
          onPressed: () {
            // LaunchUrl.customTabsUrl();
            LaunchUrl.normalLaunchUrl(url: kReleaseNotesLink);
          },
          child: Text('Release Notes'),
        ),
      ]);
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

void openContributionDialog(BuildContext context) {
  Navigator.push(context,
      MaterialPageRoute(builder: (BuildContext context) => ContributionPage()));
}
