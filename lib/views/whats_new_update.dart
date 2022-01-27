import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../CONSTANTS.dart';
import '../utils/launchUrl.dart';
import 'Settings%20part/SettingsPage.dart';

// Update Markdown body / content

class WhatsNewUpdateDialog extends StatelessWidget {
  const WhatsNewUpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //TODO: Boleh buang insetPadding ni bila xpaki LocaleSetting widget tu
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      title: Text(AppLocalizations.of(context)!.whatsUpdateTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MarkdownBody(
            data: AppLocalizations.of(context)!.whatsUpdateContent,
          ),
          const SizedBox(height: 15),
          const LocaleSetting()
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              LaunchUrl.normalLaunchUrl(url: kReleaseNotesLink);
            },
            child: Text(AppLocalizations.of(context)!.whatsUpdateChangelog)),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.whatsUpdateDismiss))
      ],
    );
  }
}
