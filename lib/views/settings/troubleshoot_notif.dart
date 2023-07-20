import 'package:app_settings/app_settings.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../CONSTANTS.dart';
import '../../utils/launch_url.dart';

final _mdStyleSheet = MarkdownStyleSheet(
    textAlign: WrapAlignment.spaceAround, textScaleFactor: 1.1);

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
              FutureBuilder<bool?>(
                future: isAutoStartAvailable,
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return const SizedBox.shrink();
                  }

                  return const _DeviceOKAdmonition();
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
                data: AppLocalizations.of(context)!
                    .notifTsPara3('$kWebsite/docs/troubleshoot/notifications'),
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

class _DeviceOKAdmonition extends StatelessWidget {
  const _DeviceOKAdmonition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.green.withOpacity(.3),
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(FontAwesomeIcons.check),
          const SizedBox(width: 15),
          Flexible(
            child: Text(AppLocalizations.of(context)!.notifTsAdmonition),
          )
        ],
      ),
    );
  }
}
