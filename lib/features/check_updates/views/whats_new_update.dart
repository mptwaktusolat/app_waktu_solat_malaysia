import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/components/mpt_bottom_dialog.dart';
import '../../../shared/constants/env.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/utils/launch_url.dart';

/// This dialog will show when user update the app
/// Called in `_showUpdateNotes()` function on `home_page.dart` file
class WhatsNewUpdateDialog extends StatelessWidget {
  const WhatsNewUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return MptBottomDialog(
      icon: const FaIcon(FontAwesomeIcons.check),
      title: AppLocalizations.of(context)!.whatsUpdateTitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MarkdownBody(
            data: AppLocalizations.of(context)!
                .whatsUpdateContent(envReleaseNotesLink),
            onTapLink: (_, href, __) => LaunchUrl.normalLaunchUrl(url: href!),
          ),
        ],
      ),
      actions: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
