import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
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
          //TODO: Copy, setting buton
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
              title: Text('Rate app'),
              leading: Icon(Icons.star),
              onTap: () {
                LaunchUrl.normalLaunchUrl(); //TODO: Add link
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
        width: 60,
        imageUrl: kAppIconUrl,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      applicationLegalese: '© Fareez 2020',
      applicationVersion: info.version,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        FlatButton(
            color: Colors.teal.shade50,
            onPressed: () {
              LaunchUrl.normalLaunchUrl(url: 'testurl');
            },
            child: Text('Privacy Policy')),
        FlatButton(
          color: Colors.teal.shade50,
          onPressed: () {
            LaunchUrl.customTabsUrl('test url ');
          },
          child: Text('Release notes'),
        )
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
