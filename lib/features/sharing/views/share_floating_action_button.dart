import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants.dart';
import '../../../providers/setting_provider.dart';
import '../../../utils/launch_url.dart';
import '../utils/share_text_builder.dart';

class ShareFloatingActionButton extends StatelessWidget {
  const ShareFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (_, setting, __) {
      return FloatingActionButton(
        mini: true,
        tooltip: AppLocalizations.of(context)!.shareTooltip,
        onPressed: () {
          switch (setting.sharingFormat) {
            case 1:
              _shareUniversal(context);
              break;
            case 2:
              _shareToWhatsApp(context);
              break;
            case 3:
              copy(context);
              break;
            default:
              showShareDialog(context);
              break;
          }
        },
        child: Builder(
          builder: (context) {
            switch (setting.sharingFormat) {
              case 2:
                return const FaIcon(FontAwesomeIcons.whatsapp);
              case 3:
                return const FaIcon(FontAwesomeIcons.clone);
              default:
                return const FaIcon(FontAwesomeIcons.shareNodes);
            }
          },
        ),
      );
    });
  }

  // TODO (Fareez): Perhaps refactor this to another component file
  void showShareDialog(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.sharePlainTitle),
              subtitle: Text(AppLocalizations.of(context)!.sharePlainDesc),
              onTap: () {
                Navigator.pop(context);
                _shareUniversal(context);
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
                _shareToWhatsApp(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.shareCopy),
              trailing: FaIcon(
                FontAwesomeIcons.clone,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onTap: () {
                copy(context);
                Navigator.pop(context);
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
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 12),
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
      },
    );
    GetStorage().write(kHasOpenSharingDialog, true);
  }

  void _shareToWhatsApp(BuildContext context) {
    final use12hourFormat =
        Provider.of<SettingProvider>(context, listen: false).use12hour;
    final message = ShareTextBuilder(AppLocalizations.of(context)!,
            use12hourFormat: use12hourFormat)
        .formatWhatsApp();
    LaunchUrl.normalLaunchUrl(
      url: 'whatsapp://send/?text=$message',
    );
  }

  void _shareUniversal(BuildContext context) {
    final use12hourFormat =
        Provider.of<SettingProvider>(context, listen: false).use12hour;
    final message = ShareTextBuilder(AppLocalizations.of(context)!,
            use12hourFormat: use12hourFormat)
        .formatPlainText();
    Share.share(message, subject: AppLocalizations.of(context)!.shareSubject);
  }

  void copy(BuildContext context) {
    final use12hourFormat =
        Provider.of<SettingProvider>(context, listen: false).use12hour;
    final message = ShareTextBuilder(AppLocalizations.of(context)!,
            use12hourFormat: use12hourFormat)
        .formatPlainText();
    Clipboard.setData(ClipboardData(text: message)).then(
      (value) {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.shareTimetableCopied);
      },
    );
  }
}
