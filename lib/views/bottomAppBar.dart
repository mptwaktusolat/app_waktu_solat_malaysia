import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/utils/copyAndShare.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
import 'package:waktusolatmalaysia/views/feedbackPage.dart';
import '../utils/AppInformation.dart';

AppInfo info = AppInfo();

class MyBottomAppBar extends StatelessWidget {
  final CopyAndShare copyAndShare = CopyAndShare();
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    String init = info.appName; //just to init the class
    return BottomAppBar(
      elevation: 18.0,
      shape: CircularNotchedRectangle(),
      color: Colors.teal[50],
      child: Row(
        children: [
          IconButton(
              tooltip: 'Open menu',
              icon: Icon(Icons.menu),
              color: Colors.grey,
              onPressed: () {
                menuModalBottomSheet(context);
              }),
          IconButton(
              icon: Icon(Icons.copy),
              tooltip: 'Copy timetable',
              color: Colors.grey,
              onPressed: () {
                copyAndShare.updateMessage();
                Clipboard.setData(
                    new ClipboardData(text: copyAndShare.getMessage()));
                Fluttertoast.showToast(msg: 'Copied');
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
              title: Text('Send feedback'),
              leading: Icon(Icons.feedback),
              onTap: () {
                Navigator.pop(context);
                print('Opening feedback dialog');
                openFeedbackDialog(context);
              },
            ),
            Divider(
              thickness: 1,
              height: 0.0,
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
  return showAboutDialog(
      context: context,
      applicationIcon: CachedNetworkImage(
        width: 45,
        imageUrl: kAppIconUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
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
            color: Colors.teal.shade50,
            onPressed: () {
              LaunchUrl.normalLaunchUrl(url: kPrivacyPolicyLink);
            },
            child: Text('Privacy Policy')),
        FlatButton(
          color: Colors.teal.shade50,
          onPressed: () {
            // LaunchUrl.customTabsUrl();
            LaunchUrl.normalLaunchUrl(url: kReleaseNotesLink);
          },
          child: Text('Release notes'),
        ),
        // FlatButton(
        //     padding: EdgeInsets.only(right: 4),
        //     color: Colors.teal.shade50,
        //     onPressed: () {},
        //     child: SvgPicture.asset('assets/svgIcons/twitter.svg',
        //         width: 10, semanticsLabel: 'A twitter logo')),
        // FlatButton(
        //   padding: EdgeInsets.only(left: 4),
        //   color: Colors.teal.shade50,
        //   onPressed: () {},
        //   child: SvgPicture.asset('assets/svgIcons/instagram.svg',
        //       width: 10, semanticsLabel: 'A instagram logo'),
        // )
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
