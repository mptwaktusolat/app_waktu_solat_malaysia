import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

import '../CONSTANTS.dart' as constants;
import '../utils/launch_url.dart';

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
              _MyCard(
                title: AppLocalizations.of(context)!.contributeShare,
                description: AppLocalizations.of(context)!.contributeShareDesc,
                actions: [
                  TextButton(
                    onPressed: () {
                      Share.share(
                          AppLocalizations.of(context)!.contributeShareContent(
                              constants.kPlayStoreListingShortLink,
                              constants.kWebappUrl),
                          subject: AppLocalizations.of(context)!
                              .contributeShareSubject);
                    },
                    child: Text(AppLocalizations.of(context)!.contributeShare),
                  ),
                ],
              ),
              const Divider(),
              _MyCard(
                title: AppLocalizations.of(context)!.contributeSource,
                description: AppLocalizations.of(context)!.contributeSourceDesc,
                actions: [
                  TextButton(
                      onPressed: () {
                        copyClipboard(context, constants.kGithubRepoLink);
                      },
                      child:
                          Text(AppLocalizations.of(context)!.contributeCopy)),
                  TextButton(
                      onPressed: () {
                        LaunchUrl.normalLaunchUrl(
                            url: constants.kGithubRepoLink);
                      },
                      child:
                          Text(AppLocalizations.of(context)!.contributeOpenGh)),
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
class _MyCard extends StatelessWidget {
  const _MyCard({
    Key? key,
    required this.title,
    this.description,
    this.extraDescription,
    this.actions,
  }) : super(key: key);

  final String title;
  final String? description;
  final String? extraDescription;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: Text('\n$description'),
            ),
            if (extraDescription != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  extraDescription!,
                  textAlign: TextAlign.start,
                ),
              ),
            if (actions != null)
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!)
          ],
        ),
      ),
    );
  }
}
