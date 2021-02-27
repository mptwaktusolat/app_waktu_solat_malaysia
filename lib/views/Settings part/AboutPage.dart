import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../CONSTANTS.dart';
import '../../utils/launchUrl.dart';
import '../Settings%20part/settingsProvider.dart';

class AboutAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<SettingProvider>(
            builder: (context, setting, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Hero(
                    tag: kAppIconTag,
                    child: Image.network(kAppIconUrl),
                  ),
                  Text(
                    '\nMPT 2021',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '\nCopyright © 2020-2021 Fareez Iqmal\n',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  //FIXME: Failed to render on web app
                  // Card(
                  //   child: ListTile(
                  //     title: Text(
                  //       'Contribution and Support',
                  //       textAlign: TextAlign.center,
                  //     ),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (BuildContext context) =>
                  //               ContributionPage(),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
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
