import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../utils/launchUrl.dart';

class TroubleshootNotif extends StatelessWidget {
  const TroubleshootNotif({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: AppLocalizations.of(context)!.notifTsPara1,
                styleSheet: MarkdownStyleSheet(
                    textAlign: WrapAlignment.spaceAround, textScaleFactor: 1.2),
              ),
              const SizedBox(height: 5),
              MarkdownBody(
                data: AppLocalizations.of(context)!.notifTsPara2,
                styleSheet: MarkdownStyleSheet(
                    textAlign: WrapAlignment.spaceAround, textScaleFactor: 1.2),
              ),
              const SizedBox(height: 5),
              Card(
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.notifTsOpenSetting),
                  onTap: () => AppSettings.openAppSettings(),
                  trailing: const Icon(Icons.launch_rounded),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.notifTsRelatedArticle,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () {
                    LaunchUrl.normalLaunchUrl(
                        url:
                            'https://telegra.ph/Notification-didnt-show-on-some-devices-07-31');
                  },
                  child:
                      const Text('Notification didn\'t show on some devices'))
            ],
          ),
        ),
      ),
    );
  }
}
