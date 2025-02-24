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
import 'share_image_preview_page.dart';
import 'share_target_selection.dart';

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
              _copy(context);
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
        return ShareTargetSelection(onShareTargetSelected: (target) {
          switch (target) {
            case ShareTarget.universal:
              _shareUniversal(context);
              break;
            case ShareTarget.whatsapp:
              _shareToWhatsApp(context);
              break;
            case ShareTarget.copy:
              _copy(context);
              break;
            case ShareTarget.image:
              _imageShare(context);
              break;
          }
        });
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

  void _copy(BuildContext context) {
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

  void _imageShare(BuildContext context) {
    // final use12hourFormat =
    //     Provider.of<SettingProvider>(context, listen: false).use12hour;
    // final message = ShareTextBuilder(AppLocalizations.of(context)!,
    //         use12hourFormat: use12hourFormat)
    //     .formatPlainText();
    // Clipboard.setData(ClipboardData(text: message)).then(
    //   (value) {
    //     Fluttertoast.showToast(
    //         msg: AppLocalizations.of(context)!.shareTimetableCopied);
    //   },
    // );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShareImagePreviewPage()),
    );
  }
}
