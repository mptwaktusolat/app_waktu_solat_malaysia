import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:waktusolatmalaysia/utils/launchUrl.dart';
import 'Settings%20part/SettingsPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Update version number
// Update Markdown body / content
// Update link changelog

class WhatsNewUpdate {
  static void showUpdateDialog(BuildContext context, String version) {
    String latestVersion = "2.3.0";
    // TODO: Add checks
    // if (version == latestVersion) {
    showDialog(context: context, builder: (_) => const WhatsNewUpdateDialog());
    // }
  }
}

class WhatsNewUpdateDialog extends StatelessWidget {
  const WhatsNewUpdateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.whatsUpdateTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MarkdownBody(
            data: AppLocalizations.of(context)!.whatsUpdateContent,
          ),
          const LocaleSetting()
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              LaunchUrl.normalLaunchUrl(url: "https://example.com");
            },
            child: Text(AppLocalizations.of(context)!.whatsUpdateChangelog)),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.whatsUpdateDismiss))
      ],
    );
  }
}
