import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
import '../../CONSTANTS.dart';
import '../contributionPage.dart';

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
      body: SingleChildScrollView(
        child: Padding(
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
                  child: Hero(
                    tag: kAppIconTag,
                    child: CachedNetworkImage(
                      width: 70,
                      imageUrl: kAppIconUrl,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '\n© Copyright 2020 Fareez Iqmal\n',
                textAlign: TextAlign.center,
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Theme.of(context).bottomAppBarColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Prayer time data are provided by Jabatan Kemajuan Islam Malaysia (JAKIM)',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Contribution and Support',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ContributionPage()));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Privacy Policy',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    LaunchUrl.normalLaunchUrl(
                        url: kPrivacyPolicyLink, usesWebView: true);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Release Notes',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    LaunchUrl.normalLaunchUrl(
                        url: kReleaseNotesLink, usesWebView: true);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Open Source Licenses',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    showLicensePage(
                        context: context,
                        applicationIcon: Hero(
                          tag: kAppIconTag,
                          child: CachedNetworkImage(
                            width: 70,
                            imageUrl: kAppIconUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
