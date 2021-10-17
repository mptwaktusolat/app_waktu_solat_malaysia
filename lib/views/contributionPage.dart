import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import '../CONSTANTS.dart' as constants;
import '../utils/launchUrl.dart';

class ButtonContent {
  String label;
  Function onClick;
  ButtonContent(this.label, this.onClick);
}

class ContributionPage extends StatelessWidget {
  const ContributionPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contribution and Support'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                  'Alhamdulillah. Thank you for your interest in donating to the Malaysia Prayer Time app. May Allah SWT rewards your kindness.'),
              const SizedBox(
                height: 8,
              ),
              MyCard(
                  title: 'Share the app',
                  description:
                      'Share your experience on using this app with your family and friends.',
                  buttonContent: [
                    ButtonContent('Share now', () {
                      Share.share(
                          "Hi. I'm using the Malaysia Prayer Time app. It's fast and free.\nTry it now:\n${constants.kPlayStoreListingShortLink} (Google Play)\n ${constants.kWebappUrl} (Web app)",
                          subject: 'Sharing MPT App');
                    })
                  ]),
              const Divider(),
              MyCard(
                title: 'Buy me a coffee?',
                description:
                    'One cup of Nescafe is usually enough for me to code all night.\n\n${constants.kBuyMeACoffeeLink.substring(12)}', //substring will remove 'https://www' stuffs.
                buttonContent: [
                  ButtonContent(
                    'Copy',
                    () => copyClipboard(constants.kBuyMeACoffeeLink),
                  ),
                  ButtonContent('Open', () {
                    LaunchUrl.normalLaunchUrl(url: constants.kBuyMeACoffeeLink);
                  })
                ],
              ),
              MyCard(
                title: 'Direct support',
                description:
                    '${constants.kBankAccountNum} - Muhammad Fareez Iqmal (Maybank)',
                buttonContent: [
                  ButtonContent(
                    'Copy',
                    () => copyClipboard(constants.kBankAccountNum),
                  ),
                ],
              ),
              MyCard(
                title: 'Contribute to source',
                description:
                    'MPT is open source. Report any bugs or contribute directly to the source code. It is licensed under GNU GPLv3.',
                buttonContent: [
                  ButtonContent(
                      'Copy', () => copyClipboard(constants.kGithubRepoLink)),
                  ButtonContent(
                      'Open GitHub',
                      () => LaunchUrl.normalLaunchUrl(
                          url: constants.kGithubRepoLink)),
                ],
              ),
              FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child:
                        SvgPicture.network(constants.kDeveloperActivityImage),
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
  MyCard({Key? key, this.title, this.description, this.buttonContent})
      : super(key: key);

  final String? title;
  final String? description;
  final List<ButtonContent>? buttonContent;
  List<TextButton> textButton = [];

  void generateButtons() {
    for (var item in buttonContent!) {
      textButton.add(TextButton(
          onPressed: item.onClick as void Function()?,
          child: Text(item.label)));
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
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                title!,
                style: const TextStyle(fontSize: 18),
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
