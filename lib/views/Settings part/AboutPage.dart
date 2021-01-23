import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../CONSTANTS.dart';
import '../../main.dart';
import '../../utils/launchUrl.dart';
import '../../utils/notifications_helper.dart';
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
                    print('Show debug dialog');
                    var prayApiCalled =
                        GetStorage().read(kStoredApiPrayerCall) ?? 'no calls';
                    var locApiCalled =
                        GetStorage().read(kStoredApiLocationCall) ?? 'no calls';
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.all(8.0),
                          children: [
                            Text(
                              'For dev (Api call history)',
                              textAlign: TextAlign.center,
                            ),
                            ListTile(
                              title: Text('Prayer time API calls'),
                              subtitle: Text(prayApiCalled),
                              onLongPress: () {
                                Clipboard.setData(
                                        ClipboardData(text: prayApiCalled))
                                    .then((value) => Fluttertoast.showToast(
                                        msg: 'Copied url'));
                              },
                            ),
                            ListTile(
                              title: Text('Prayer location API calls'),
                              subtitle: Text(locApiCalled),
                              onLongPress: () {
                                Clipboard.setData(
                                        ClipboardData(text: locApiCalled))
                                    .then((value) => Fluttertoast.showToast(
                                        msg: 'Copied url'));
                              },
                            ),
                            ListTile(
                              title: Text('Send immediate test notification'),
                              onTap: () async {
                                await showDebugNotification();
                              },
                            ),
                            ListTile(
                              title: Text('Send alert test in one miniute'),
                              subtitle: Text('Payload: $kPayloadDebug'),
                              onTap: () async {
                                await scheduleAlertNotification(
                                    notifsPlugin: notifsPlugin,
                                    title: 'debug payload',
                                    id: 219, //randrom int haha
                                    body: 'With payload',
                                    payload: kPayloadDebug,
                                    scheduledTime:
                                        tz.TZDateTime.now(tz.local).add(
                                      Duration(minutes: 1),
                                    ));
                              },
                            ),
                            ListTile(
                                title: Text('Global location index'),
                                subtitle: Text(
                                    '${GetStorage().read(kStoredGlobalIndex)}'))
                          ],
                        ),
                      ),
                    );
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
                '\n© Copyright 2020-2021 Fareez Iqmal\n',
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
                        url: kPrivacyPolicyLink, useCustomTabs: true);
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
                        url: kReleaseNotesLink, useCustomTabs: true);
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
              Divider(height: 8),
              Card(
                child: ListTile(
                  title: Text('Twitter', textAlign: TextAlign.center),
                  onTap: () {
                    LaunchUrl.normalLaunchUrl(url: kDevTwitter);
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    'Dev logs',
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    LaunchUrl.normalLaunchUrl(url: kInstaStoryDevlog);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
