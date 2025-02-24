import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';

import '../../../constants.dart';
import '../utils/share_text_builder.dart';

/// Share sheet display share target
class ShareTargetSelection extends StatelessWidget {
  const ShareTargetSelection({super.key, required this.onShareTargetSelected});

  final Function(ShareTarget target) onShareTargetSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.sharePlainTitle),
          subtitle: Text(AppLocalizations.of(context)!.sharePlainDesc),
          trailing: FaIcon(
            FontAwesomeIcons.font,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onTap: () {
            Navigator.pop(context);
            onShareTargetSelected(ShareTarget.universal);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.shareWhatsappTitle),
          subtitle: Text(AppLocalizations.of(context)!.shareWhatsappDesc),
          trailing: FaIcon(
            FontAwesomeIcons.whatsapp,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onTap: () {
            Navigator.pop(context);
            onShareTargetSelected(ShareTarget.whatsapp);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.shareCopy),
          trailing: FaIcon(
            FontAwesomeIcons.clone,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onTap: () {
            Navigator.pop(context);
            onShareTargetSelected(ShareTarget.copy);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.shareImage),
          trailing: FaIcon(
            FontAwesomeIcons.image,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onTap: () {
            Navigator.pop(context);
            onShareTargetSelected(ShareTarget.image);
          },
        ),
        // Message should only show once
        // Show only if it is not open before
        if (!(GetStorage().read<bool?>(kHasOpenSharingDialog) ?? false))
          Padding(
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(
                text: AppLocalizations.of(context)!.shareSettingPrompt,
                style:
                    DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
                children: <TextSpan>[
                  TextSpan(
                      text: AppLocalizations.of(context)!
                          .shareSettingPromptDestination,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
