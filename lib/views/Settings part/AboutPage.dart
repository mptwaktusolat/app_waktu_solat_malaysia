import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/settingsProvider.dart';
import '../../CONSTANTS.dart';
import '../../utils/launchUrl.dart';
import '../contributionPage.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isFirstTry = true;
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<SettingProvider>(
            builder: (context, setting, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          GetStorage().write(kDiscoveredDeveloperOption, true);
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
                                    Clipboard.setData(
                                            ClipboardData(text: prayApiCalled))
                                        .then((value) => Fluttertoast.showToast(
                                            msg: 'Copied url'));
                                  },
                                ),
                                //TODO: Remove this later ok
                                ListTile(
                                  title: Text(
                                    'Prayer location API calls',
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                  subtitle:
                                      Text('Will remove on future release'),
                                ),

                                ListTile(
                                    title: Text('Global location index'),
                                    subtitle: Text(
                                        '${GetStorage().read(kStoredGlobalIndex)}')),

                                ListTile(
                                  title:
                                      Text('Number of scheduled notification'),
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
                      child: Image.network(kAppIconUrl),
                    ),
                  ),
                  Text(
                    '\nMPT 2021',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '\nCopyright © 2020-2021 Fareez Iqmal\n',
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).bottomAppBarColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: GestureDetector(
                      onTap: () {
                        LaunchUrl.normalLaunchUrl(url: kSolatJakimLink);
                      },
                      child: Text(
                        'Jabatan Kemajuan Islam Malaysia (JAKIM) provides prayer time data. Visit www.e-solat.gov.my for more info.',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
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
                        LaunchUrl.normalLaunchUrl(url: kPrivacyPolicyLink);
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
                        LaunchUrl.normalLaunchUrl(url: kReleaseNotesLink);
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
                              child: Image.network(
                                kAppIconUrl,
                                width: 50,
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
              );
            },
          ),
        ),
      ),
    );
  }
}
