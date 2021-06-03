import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import '../CONSTANTS.dart' as Constants;
import '../utils/launchUrl.dart';

class ButtonContent {
  String label;
  Function onClick;
  ButtonContent(this.label, this.onClick);
}

class ContributionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contribution and Support'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                  'Alhamdulillah. Thank you for your interest in donating to the Malaysia Prayer Time app. May Allah SWT rewards your kindness.'),
              SizedBox(
                height: 8,
              ),
              MyCard(
                  title: 'Share the app',
                  description:
                      'Share your experience on using this app with your family and friends.',
                  buttonContent: [
                    ButtonContent('Share now', () {
                      Share.share(
                          "Hi. I'm using the Malaysia Prayer Time app. It's fast and free.\nTry it now:\n${Constants.kPlayStoreListingShortLink} (Google Play)\n ${Constants.kWebappUrl} (Web app)",
                          subject: 'Sharing MPT App');
                    })
                  ]),
              Divider(),
              MyCard(
                title: 'Buy me a coffee?',
                description:
                    'One cup of Nescafe is usually enough for me to code all night.\n\n${Constants.kBuyMeACoffeeLink.substring(12)}', //substring will remove 'https://www' stuffs.
                buttonContent: [
                  ButtonContent(
                    'Copy',
                    () => copyClipboard(Constants.kBuyMeACoffeeLink),
                  ),
                  ButtonContent('Open', () {
                    LaunchUrl.normalLaunchUrl(url: Constants.kBuyMeACoffeeLink);
                  })
                ],
              ),
              MyCard(
                title: 'Direct support',
                description:
                    '${Constants.kMaybankAccNo} - Muhammad Fareez Iqmal (Maybank)',
                buttonContent: [
                  ButtonContent(
                    'Copy',
                    () => copyClipboard(Constants.kMaybankAccNo),
                  ),
                ],
              ),
              MyCard(
                title: 'Contribute to source',
                description:
                    'MPT is now open source. Report any bugs or contribute directly to the source code. It is licensed under GNU GPLv3.',
                buttonContent: [
                  ButtonContent(
                      'Copy', () => copyClipboard(Constants.kGithubRepoLink)),
                  ButtonContent(
                      'Open GitHub',
                      () => LaunchUrl.normalLaunchUrl(
                          url: Constants.kGithubRepoLink)),
                ],
              ),
              FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child:
                        SvgPicture.network(Constants.kDeveloperActivityImage),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void copyClipboard(String url) {
    Clipboard.setData(ClipboardData(text: url))
        .then((value) => Fluttertoast.showToast(msg: 'Copied to clipboard'));
  }
}

// ignore: must_be_immutable
class MyCard extends StatelessWidget {
  MyCard({Key key, this.title, this.description, this.buttonContent})
      : super(key: key);

  final String title;
  final String description;
  final List<ButtonContent> buttonContent;
  List<TextButton> textButton = [];

  void generateButtons() {
    for (var item in buttonContent) {
      textButton
          .add(TextButton(onPressed: item.onClick, child: Text(item.label)));
    }
  }

  @override
  Widget build(BuildContext context) {
    generateButtons();
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(
                title,
                style: TextStyle(fontSize: 18),
              ),
              subtitle: Text('\n$description'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: textButton,
            )
          ],
        ),
      ),
    );
  }
}
