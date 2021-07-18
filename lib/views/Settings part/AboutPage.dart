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
import '../../CONSTANTS.dart';
import '../../locationUtil/LocationData.dart';
import '../../main.dart';
import '../../notificationUtil/notifications_helper.dart';
import '../../utils/launchUrl.dart';
import '../Settings%20part/settingsProvider.dart';
import '../contributionPage.dart';
import '../faq.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({Key key, this.packageInfo}) : super(key: key);
  final PackageInfo packageInfo;
  final appLegalese = 'Copyright © 2020-2021 Fareez Iqmal';

  void showDebugDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) => Dialog(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          children: [
            const Text(
              'Debug dialog (for dev)',
              textAlign: TextAlign.center,
            ),
            ListTile(
              title: const Text('Prayer time API calls'),
              subtitle: Text(
                  GetStorage().read(kStoredApiPrayerCall) ?? 'no calls yet'),
              onLongPress: () {
                Clipboard.setData(ClipboardData(
                        text: GetStorage().read(kStoredApiPrayerCall) ??
                            'no calls yet'))
                    .then((value) => Fluttertoast.showToast(msg: 'Copied url'));
              },
            ),
            ListTile(
              title: const Text('Last position'),
              subtitle: Text(LocationData.position.toString() ?? 'no detect'),
              onLongPress: () {
                Clipboard.setData(ClipboardData(
                        text: LocationData.position.toString() ?? 'no detect'))
                    .then((value) =>
                        Fluttertoast.showToast(msg: 'Copied position'));
              },
            ),
            ListTile(
              title: const Text('Send immediate test notification'),
              onTap: () async {
                await showDebugNotification();
              },
            ),
            ListTile(
              title: const Text('Send alert test in one minute'),
              subtitle: const Text('Payload: $kPayloadDebug'),
              onTap: () async {
                await scheduleAlertNotification(
                    notifsPlugin: notifsPlugin,
                    title: 'debug payload',
                    id: 219, //randrom int haha
                    body: 'With payload',
                    payload: kPayloadDebug,
                    scheduledTime: tz.TZDateTime.now(tz.local).add(
                      const Duration(minutes: 1),
                    ));
              },
            ),
            ListTile(
                title: const Text('Global location index'),
                subtitle: Text('${GetStorage().read(kStoredGlobalIndex)}')),
            ListTile(
              title: const Text('Last update notification'),
              subtitle: Text(DateTime.fromMillisecondsSinceEpoch(
                      GetStorage().read(kStoredLastUpdateNotif))
                  .toString()),
              onLongPress: () {
                Clipboard.setData(ClipboardData(
                        text: GetStorage()
                            .read(kStoredLastUpdateNotif)
                            .toString()))
                    .then((value) =>
                        Fluttertoast.showToast(msg: 'Copied millis'));
              },
            ),
            ListTile(
              title: const Text('Number of scheduled notification'),
              subtitle:
                  Text(GetStorage().read(kNumberOfNotifsScheduled).toString()),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstTry = true;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('About App'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                        if (isFirstTry && !setting.isDeveloperOption) {
                          Fluttertoast.showToast(msg: '(⌐■_■)');
                          isFirstTry = false;
                        } else {
                          if (!setting.isDeveloperOption) {
                            Fluttertoast.showToast(
                                msg: 'Developer mode discovered',
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.teal);

                            setting.isDeveloperOption = true;
                          }
                          showDebugDialog(context);
                        }
                      },
                      child: Hero(
                        tag: kAppIconTag,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                            width: 70,
                            height: 70,
                            fit: BoxFit.scaleDown,
                            imageUrl: kAppIconUrl,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                const FaIcon(FontAwesomeIcons.exclamation),
                          ),
                        ),
                      ),
                    ),
                    const Text(
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
                        padding: const EdgeInsets.all(8),
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
                              const TextSpan(
                                text: 'Prayer data are fetched from',
                              ),
                              TextSpan(
                                text:
                                    ' Jabatan Kemajuan Islam Malaysia (e-solat)',
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    LaunchUrl.normalLaunchUrl(
                                        url: kSolatJakimLink);
                                  },
                              ),
                              const TextSpan(
                                text: ' tunnelled through ',
                              ),
                              TextSpan(
                                text: 'mpti906 API',
                                style:
                                    const TextStyle(color: Colors.blueAccent),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    LaunchUrl.normalLaunchUrl(
                                        url: kMptWebsiteLink);
                                  },
                              ),
                              const TextSpan(text: '.')
                            ],
                          ),
                        )),
                    const SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        title: const Text(
                          'Contribution and Support',
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const ContributionPage()));
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
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
                        title: const Text(
                          'Frequently Asked Questions (FAQ)',
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FaqPage(),
                            ),
                          );
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
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
                                      const Icon(Icons.error),
                                ),
                              ));
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
                          'Privacy Policy',
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          LaunchUrl.normalLaunchUrl(
                              url: kPrivacyPolicyLink, useCustomTabs: true);
                        },
                      ),
                    ),
                    const Divider(height: 8, thickness: 2),
                    Card(
                      child: ListTile(
                          title: const Text('More apps from me',
                              textAlign: TextAlign.center),
                          onTap: () {
                            LaunchUrl.normalLaunchUrl(url: kPlayStoreDevLink);
                          }),
                    ),
                    Card(
                      child: ListTile(
                        title:
                            const Text('Twitter', textAlign: TextAlign.center),
                        onTap: () {
                          LaunchUrl.normalLaunchUrl(url: kDevTwitter);
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        title: const Text(
                          'Dev logs',
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          LaunchUrl.normalLaunchUrl(url: kInstaStoryDevlog);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Opacity(
                        opacity: 0.58,
                        child: Text(
                          appLegalese,
                          textAlign: TextAlign.center,
                        ),
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
