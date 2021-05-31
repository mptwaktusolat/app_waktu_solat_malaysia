import 'package:flutter/material.dart';
import '../../CONSTANTS.dart';
import '../../utils/launchUrl.dart';
import '../contributionPage.dart';

class AboutAppPage extends StatelessWidget {
  Widget topPart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Hero(
          tag: kAppIconTag,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              'assets/mpt-logo.png',
              height: 105,
            ),
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
      ],
    );
  }

  Widget bottomPart(BuildContext ctx) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: ListTile(
            title: Text(
              'Contribution and Support',
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.push(
                ctx,
                MaterialPageRoute(
                  builder: (BuildContext context) => ContributionPage(),
                ),
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text(
              'GitHub',
              textAlign: TextAlign.center,
            ),
            onTap: () {
              LaunchUrl.normalLaunchUrl(url: kGithubRepoLink);
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
                context: ctx,
                applicationIcon: Hero(
                  tag: kAppIconTag,
                  child: Image.asset(
                    'assets/mpt-logo.png',
                    width: 50,
                  ),
                ),
              );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About App'),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 660) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    topPart(),
                    bottomPart(context),
                  ],
                ),
              ),
            );
          } else {
            return Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: topPart()),
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 28, 12, 1),
                      child: bottomPart(context),
                    )),
              ],
            );
          }
        },
      ),
    );
  }
}
