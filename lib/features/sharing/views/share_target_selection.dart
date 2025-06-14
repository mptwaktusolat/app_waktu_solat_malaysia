import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../l10n/app_localizations.dart';
import '../utils/share_text_builder.dart';

/// A widget that displays different sharing options in a bottom sheet.
///
/// Provides users with multiple options for sharing prayer times, including
/// plain text, WhatsApp, clipboard copy, and image sharing.
class ShareTargetSelection extends StatelessWidget {
  /// Creates a new [ShareTargetSelection] widget.
  ///
  /// [onShareTargetSelected] is called when the user selects a sharing option.
  const ShareTargetSelection({super.key, required this.onShareTargetSelected});

  /// Callback function triggered when user selects a sharing target.
  final Function(ShareTarget target) onShareTargetSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appLocalizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildShareOption(
          context: context,
          title: appLocalizations.sharePlainTitle,
          subtitle: appLocalizations.sharePlainDesc,
          icon: FontAwesomeIcons.font,
          color: colorScheme.secondary,
          target: ShareTarget.universal,
        ),
        _buildShareOption(
          context: context,
          title: appLocalizations.shareWhatsappTitle,
          subtitle: appLocalizations.shareWhatsappDesc,
          icon: FontAwesomeIcons.whatsapp,
          color: colorScheme.secondary,
          target: ShareTarget.whatsapp,
        ),
        _buildShareOption(
          context: context,
          title: appLocalizations.shareCopy,
          subtitle: null,
          icon: FontAwesomeIcons.clone,
          color: colorScheme.secondary,
          target: ShareTarget.copy,
        ),
        _buildShareOption(
          context: context,
          title: appLocalizations.shareImage,
          subtitle: null,
          icon: FontAwesomeIcons.image,
          color: colorScheme.secondary,
          target: ShareTarget.image,
        ),
      ],
    );
  }

  /// Helper method to build a consistent share option list tile.
  Widget _buildShareOption({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required ShareTarget target,
    String? subtitle,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: FaIcon(icon, color: color),
      onTap: () {
        Navigator.pop(context);
        onShareTargetSelected(target);
      },
    );
  }
}
