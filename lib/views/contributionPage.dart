import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart' as Constants;
import 'package:waktusolatmalaysia/utils/launchUrl.dart';

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
                  'Alhamdulillah. Thank you for your interest in donating to Malaysia Prayer Time app. May Allah SWT reward your kindness.'),
              SizedBox(
                height: 8,
              ),
              MyCard(
                  title: 'Share the app',
                  description:
                      'One of tiny acts of kindness. Share your experience on using this app to your family and friends.',
                  buttonContent: [
                    ButtonContent('Share the app', () {
                      print('pressed form class');
                    })
                  ]),
              Divider(),
              MyCard(
                title: 'Buy me a coffee?',
                description:
                    'One cup of nescafe usually enough for me to code all night.\n\n${Constants.kBuyMeACoffeeLink.substring(12)}', //substring will remove 'https://www' stuffs.
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
                title: 'Donate via PayPal',
                description: '${Constants.kPaypalDonateShortLink}',
                buttonContent: [
                  ButtonContent(
                    'Copy',
                    () => copyClipboard(Constants.kPaypalDonateFullLink),
                  ),
                  ButtonContent(
                    'Open',
                    () => LaunchUrl.normalLaunchUrl(
                        url: Constants.kPaypalDonateFullLink),
                  ),

                  //TODO: Add any illustrattion
                ],
              ),
              MyCard(
                title: 'Contribute to source',
                description:
                    'MPT is now open source. Report any bugs or contribute directly to the source code. Licensed under GNU GPLv3',
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
                    padding: const EdgeInsets.all(18.0),
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
