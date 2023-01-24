import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../CONSTANTS.dart';
import '../providers/setting_provider.dart';
import 'copy_and_share.dart';
import 'launch_url.dart';

class ShareFAB extends StatelessWidget {
  const ShareFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (_, setting, __) {
      return FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        mini: true,
        tooltip: AppLocalizations.of(context)!.shareTooltip,
        onPressed: () {
          switch (setting.sharingFormat) {
            case 1:
              shareUniversal(context);
              break;
            case 2:
              shareToWhatsApp(context);
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
                shareUniversal(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.shareWhatsappTitle),
              subtitle: Text(AppLocalizations.of(context)!.shareWhatsappDesc),
              trailing: const FaIcon(FontAwesomeIcons.whatsapp),
              onTap: () {
                Navigator.pop(context);
                shareToWhatsApp(context);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.shareCopy),
              trailing: const FaIcon(FontAwesomeIcons.clone),
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

  void shareToWhatsApp(BuildContext context) {
    var message =
        CopyAndShare.getMessage(context, shareTarget: ShareTarget.whatsapp);
    LaunchUrl.normalLaunchUrl(
      url: 'whatsapp://send/?text=$message',
    );
  }

  void shareUniversal(BuildContext context) =>
      Share.share(CopyAndShare.getMessage(context),
          subject: AppLocalizations.of(context)!.shareSubject);

  void copy(BuildContext context) =>
      Clipboard.setData(ClipboardData(text: CopyAndShare.getMessage(context)))
          .then(
        (value) {
          Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.shareTimetableCopied);
        },
      );
}
