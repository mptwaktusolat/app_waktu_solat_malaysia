import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:waktusolatmalaysia/views/Settings%20part/settingsProvider.dart';
import 'package:waktusolatmalaysia/views/faq.dart';
import '../../CONSTANTS.dart';
import '../../main.dart';
import '../../utils/launchUrl.dart';
import '../../utils/notifications_helper.dart';
import '../contributionPage.dart';

class AboutAppPage extends StatelessWidget {
  AboutAppPage(this.packageInfo);
  final PackageInfo packageInfo;
  final appLegalese = 'Copyright © 2020-2021 Fareez Iqmal';
  @override
  Widget build(BuildContext context) {
    bool isFirstTry = true;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('About App'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
            child: Consumer<SettingProvider>(
              builder: (context, setting, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        if (isFirstTry &&
                            !GetStorage().read(kDiscoveredDeveloperOption)) {
                          Fluttertoast.showToast(msg: '(⌐■_■)');
                          isFirstTry = false;
                        } else {
                          if (!GetStorage().read(kDiscoveredDeveloperOption)) {
                            Fluttertoast.showToast(
                                msg: 'Developer mode discovered',
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.teal);
                            GetStorage()
                                .write(kDiscoveredDeveloperOption, true);
                            setting.isDeveloperOption = true;
                          } else {
                            print('Dev mode already enabled');
                          }
                          var prayApiCalled =
                              GetStorage().read(kStoredApiPrayerCall) ??
                                  'no calls yet';

                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.all(8.0),
                                children: [
                                  Text(
                                    'Debug dialog (for dev)',
                                    textAlign: TextAlign.center,
                                  ),
                                  ListTile(
                                    title: Text('Prayer time API calls'),
                                    subtitle: Text(prayApiCalled),
                                    onLongPress: () {
                                      Clipboard.setData(ClipboardData(
                                              text: prayApiCalled))
                                          .then((value) =>
                                              Fluttertoast.showToast(
                                                  msg: 'Copied url'));
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                        'Send immediate test notification'),
                                    onTap: () async {
                                      await showDebugNotification();
                                    },
                                  ),
                                  ListTile(
                                    title:
                                        Text('Send alert test in one miniute'),
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
                                          '${GetStorage().read(kStoredGlobalIndex)}')),
                                  ListTile(
                                    title: Text('Last update notification'),
                                    subtitle: Text(
                                        DateTime.fromMillisecondsSinceEpoch(
                                                GetStorage().read(
                                                    kStoredLastUpdateNotif))
                                            .toString()),
                                    onLongPress: () {
                                      Clipboard.setData(ClipboardData(
                                              text: GetStorage()
                                                  .read(kStoredLastUpdateNotif)
                                                  .toString()))
                                          .then((value) =>
                                              Fluttertoast.showToast(
                                                  msg: 'Copied millis'));
                                    },
                                  ),
                                  ListTile(
                                    title: Text(
                                        'Number of scheduled notification'),
                                    subtitle: Text(GetStorage()
                                        .read(kNumberOfNotifsScheduled)
                                        .toString()),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      child: Hero(
                        tag: kAppIconTag,
                        child: CachedNetworkImage(
                          width: 70,
                          height: 70,
                          fit: BoxFit.scaleDown,
                          imageUrl: kAppIconUrl,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => SizedBox(
                            height: 70,
                            width: 70,
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress),
                          ),
                          errorWidget: (context, url, error) =>
                              FaIcon(FontAwesomeIcons.exclamation),
                        ),
                      ),
                    ),
                    Text(
                      '\nMPT 2021',
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onLongPress: () {
                        Clipboard.setData(
                                ClipboardData(text: packageInfo.version))
                            .then((value) => Fluttertoast.showToast(
                                msg: 'Copied version info'));
                      },
                      child: Text(
                        'Version ${packageInfo.version}\n',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).bottomAppBarColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color),
                            children: [
                              TextSpan(
                                text: 'Prayer data fetched from',
                              ),
                              TextSpan(
                                text:
                                    ' Jabatan Kemajuan Islam Malaysia (e-solat JAKIM)',
                                style: TextStyle(color: Colors.blueAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    LaunchUrl.normalLaunchUrl(
                                        url: kSolatJakimLink);
                                  },
                              ),
                              TextSpan(
                                text: ' tunnelled through ',
                              ),
                              TextSpan(
                                text: 'mpti906 API',
                                style: TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    LaunchUrl.normalLaunchUrl(
                                        url: kMptWebsiteLink);
                                  },
                              ),
                              TextSpan(text: '.')
                            ],
                          ),
                        )
                        //   child: SelectableText(
                        //     '  mpti906 API. Visit www.e-solat.gov.my for more info.',
                        //     onTap: () =>
                        //         LaunchUrl.normalLaunchUrl(url: kSolatJakimLink),
                        //     style: TextStyle(
                        //       fontStyle: FontStyle.italic,
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   ),
                        ),
                    SizedBox(height: 8),
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
                          'Frequently Asked Questions (FAQ)',
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FaqPage(),
                            ),
                          );
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
                              applicationName: packageInfo.appName,
                              applicationVersion: packageInfo.version,
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
                    Divider(height: 8, thickness: 2),
                    Card(
                      child: ListTile(
                          title: Text('More apps from me',
                              textAlign: TextAlign.center),
                          onTap: () {
                            LaunchUrl.normalLaunchUrl(url: kPlayStoreDevLink);
                          }),
                    ),
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
                    ),
                    SizedBox(height: 15),
                    Opacity(
                      opacity: 0.58,
                      child: Text(
                        appLegalese,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
