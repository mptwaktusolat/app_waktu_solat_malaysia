import 'package:admonitions/admonitions.dart';
import 'package:app_settings/app_settings.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../env.dart';
import '../../shared/utils/launch_url.dart';

final _mdStyleSheet = MarkdownStyleSheet(
  textAlign: WrapAlignment.spaceAround,
  textScaler: const TextScaler.linear(1.1),
);

class TroubleshootNotif extends StatelessWidget {
  const TroubleshootNotif({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<bool?>(
                future: isAutoStartAvailable,
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return const SizedBox.shrink();
                  }

                  return PastelAdmonition.tip(
                    text: AppLocalizations.of(context)!.notifTsAdmonition,
                    icon: FaIcon(
                      FontAwesomeIcons.check,
                    ),
                  );
                },
              ),
              MarkdownBody(
                  data: AppLocalizations.of(context)!.notifTsPara1,
                  styleSheet: _mdStyleSheet),
              const SizedBox(height: 5),
              MarkdownBody(
                  data: AppLocalizations.of(context)!.notifTsPara2,
                  styleSheet: _mdStyleSheet),
              const SizedBox(height: 5),
              Card(
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.notifTsOpenSetting),
                  onTap: () => AppSettings.openAppSettings(),
                  trailing: const Icon(Icons.launch_rounded),
                ),
              ),
              const SizedBox(height: 5),
              MarkdownBody(
                data: AppLocalizations.of(context)!.notifTsPara3(
                  Uri.parse(envAppSupportWebsite)
                      .resolve('/docs/troubleshoot/notifications')
                      .toString(),
                ),
                onTapLink: (_, href, __) =>
                    LaunchUrl.normalLaunchUrl(url: href!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
