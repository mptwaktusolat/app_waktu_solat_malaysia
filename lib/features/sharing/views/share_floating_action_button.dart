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

/// A floating action button that provides prayer time sharing functionality.
///
/// This widget allows users to quickly share prayer times through various
/// methods, including system share, WhatsApp, clipboard, or as an image.
class ShareFloatingActionButton extends StatelessWidget {
  const ShareFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(builder: (_, setting, __) {
      final localizations = AppLocalizations.of(context)!;

      return FloatingActionButton(
        mini: true,
        tooltip: localizations.shareTooltip,
        onPressed: () =>
            _handleShareButtonPressed(context, setting.sharingFormat),
        child: _buildShareIcon(setting.sharingFormat),
      );
    });
  }

  /// Handles the share button press based on user's preferred sharing format.
  ///
  /// [context] The build context.
  /// [sharingFormat] The user's preferred sharing format from settings.
  void _handleShareButtonPressed(BuildContext context, int sharingFormat) {
    switch (sharingFormat) {
      case 1:
        shareUniversal(context);
        break;
      case 2:
        shareToWhatsApp(context);
        break;
      case 3:
        copyToClipboard(context);
        break;
      default:
        showShareDialog(context);
        break;
    }
  }

  /// Builds the appropriate icon based on the sharing format.
  Widget _buildShareIcon(int sharingFormat) {
    switch (sharingFormat) {
      case 2:
        return const FaIcon(FontAwesomeIcons.whatsapp);
      case 3:
        return const FaIcon(FontAwesomeIcons.clone);
      default:
        return const FaIcon(FontAwesomeIcons.shareNodes);
    }
  }

  /// Shows a modal bottom sheet with sharing options.
  ///
  /// This method also marks that the user has seen the sharing dialog.
  Future<void> showShareDialog(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return ShareTargetSelection(
          onShareTargetSelected: (target) =>
              _handleShareTargetSelection(context, target),
        );
      },
    );
    // Mark that the user has seen the sharing dialog
    await GetStorage().write(kHasOpenSharingDialog, true);
  }

  /// Handles the selected sharing target from the share dialog.
  void _handleShareTargetSelection(BuildContext context, ShareTarget target) {
    switch (target) {
      case ShareTarget.universal:
        shareUniversal(context);
        break;
      case ShareTarget.whatsapp:
        shareToWhatsApp(context);
        break;
      case ShareTarget.copy:
        copyToClipboard(context);
        break;
      case ShareTarget.image:
        shareAsImage(context);
        break;
    }
  }

  /// Shares prayer times directly to WhatsApp.
  ///
  /// Formats the text specifically for WhatsApp and opens the WhatsApp app.
  void shareToWhatsApp(BuildContext context) {
    final use12hourFormat =
        Provider.of<SettingProvider>(context, listen: false).use12hour;
    final message = ShareTextBuilder(AppLocalizations.of(context)!,
            use12hourFormat: use12hourFormat)
        .formatWhatsApp();

    LaunchUrl.normalLaunchUrl(
      url: 'whatsapp://send/?text=$message',
    );
  }

  /// Shares prayer times using the system share dialog.
  ///
  /// Uses the plain text format to share with any app.
  void shareUniversal(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final use12hourFormat =
        Provider.of<SettingProvider>(context, listen: false).use12hour;
    final message =
        ShareTextBuilder(localizations, use12hourFormat: use12hourFormat)
            .formatPlainText();

    Share.share(message, subject: localizations.shareSubject);
  }

  /// Copies prayer times to the clipboard.
  ///
  /// Shows a toast message when copying is successful.
  void copyToClipboard(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final use12hourFormat =
        Provider.of<SettingProvider>(context, listen: false).use12hour;
    final message =
        ShareTextBuilder(localizations, use12hourFormat: use12hourFormat)
            .formatPlainText();

    Clipboard.setData(ClipboardData(text: message)).then(
      (_) => Fluttertoast.showToast(msg: localizations.shareTimetableCopied),
    );
  }

  /// Opens the image sharing preview page.
  ///
  /// Allows users to select a prayer time card design and share it as an image.
  void shareAsImage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShareImagePreviewPage()),
    );
  }
}
