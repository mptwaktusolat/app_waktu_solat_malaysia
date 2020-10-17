import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
import '../../CONSTANTS.dart';

class AboutAppPage extends StatelessWidget {
  AboutAppPage(this.appInfo);
  final appInfo;
  @override
  Widget build(BuildContext context) {
    bool isFirstTry = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CachedNetworkImage(
                  width: 90,
                  imageUrl: kAppIconUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Text(
              '\nMPT 2020',
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: appInfo.version)).then(
                    (value) =>
                        Fluttertoast.showToast(msg: 'Copied version info'));
              },
              child: Text(
                '\nVersion ${appInfo.version}',
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              '\n© Copyright 2020 Fareez Iqmal',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              child: ListTile(
                title: Text('Privacy Policy'),
                onTap: () {
                  LaunchUrl.normalLaunchUrl(
                      url: kPrivacyPolicyLink, usesWebView: true);
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Release Notes'),
                onTap: () {
                  LaunchUrl.normalLaunchUrl(
                      url: kReleaseNotesLink, usesWebView: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
