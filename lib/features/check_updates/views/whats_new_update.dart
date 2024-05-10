import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../env.dart';
import '../../../utils/launch_url.dart';

/// This dialog will show when user update the app
/// Called in `_showUpdateNotes()` function on `appBody.dart` file
class WhatsNewUpdateDialog extends StatelessWidget {
  const WhatsNewUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.whatsUpdateTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MarkdownBody(
            // styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.spaceAround),
            data: AppLocalizations.of(context)!
                .whatsUpdateContent(envReleaseNotesLink),
            onTapLink: (_, href, __) => LaunchUrl.normalLaunchUrl(url: href!),
          ),
        ],
      ),
    );
  }
}
