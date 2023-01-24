import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '../CONSTANTS.dart' as constants;
import '../utils/launch_url.dart';

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
        title: Text(AppLocalizations.of(context)!.aboutContribution),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(AppLocalizations.of(context)!.contributenDesc),
              ),
              const SizedBox(height: 8),
              MyCard(
                  title: AppLocalizations.of(context)!.contributeShare,
                  description:
                      AppLocalizations.of(context)!.contributeShareDesc,
                  buttonContent: [
                    ButtonContent(
                        AppLocalizations.of(context)!.contributeShareNow, () {
                      Share.share(
                          AppLocalizations.of(context)!.contributeShareContent(
                              constants.kPlayStoreListingShortLink,
                              constants.kWebappUrl),
                          subject: AppLocalizations.of(context)!
                              .contributeShareSubject);
                    })
                  ]),
              const Divider(),
              MyCard(
                title: AppLocalizations.of(context)!.contributeCoffee,
                description: AppLocalizations.of(context)!.contributeCoffeeDesc(
                    constants.kBuyMeACoffeeLink
                        .replaceFirst("https://www.", "")),
                buttonContent: [
                  ButtonContent(
                    AppLocalizations.of(context)!.contributeCopy,
                    () => copyClipboard(context, constants.kBuyMeACoffeeLink),
                  ),
                  ButtonContent(AppLocalizations.of(context)!.contributeOpen,
                      () {
                    LaunchUrl.normalLaunchUrl(url: constants.kBuyMeACoffeeLink);
                  })
                ],
              ),
              MyCard(
                title: AppLocalizations.of(context)!.contributeDirect,
                description:
                    '${constants.kBankAccountNum} - Muhammad Fareez Iqmal (Maybank)',
                buttonContent: [
                  ButtonContent(
                    AppLocalizations.of(context)!.contributeCopy,
                    () => copyClipboard(context, constants.kBankAccountNum),
                  ),
                ],
              ),
              MyCard(
                title: AppLocalizations.of(context)!.contributeSource,
                description: AppLocalizations.of(context)!.contributeSourceDesc,
                buttonContent: [
                  ButtonContent(AppLocalizations.of(context)!.contributeCopy,
                      () => copyClipboard(context, constants.kGithubRepoLink)),
                  ButtonContent(
                      AppLocalizations.of(context)!.contributeOpenGh,
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

  void copyClipboard(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url)).then((value) =>
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.contributeCopied));
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
