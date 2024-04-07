import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';

import '../../../constants.dart';
import 'qibla_page.dart';

class QiblaDisclaimerPage extends StatelessWidget {
  const QiblaDisclaimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 20),
        child: Column(
          children: [
            const Spacer(),
            FaIcon(FontAwesomeIcons.triangleExclamation,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.green
                    : Colors.green.shade700,
                size: 45),
            const SizedBox(height: 15),
            MarkdownBody(
              data: AppLocalizations.of(context)!.qiblaWarnBody,
              styleSheet: MarkdownStyleSheet(
                  unorderedListAlign: WrapAlignment.spaceBetween),
            ),
            SvgPicture.asset(
              'assets/qibla/compass callibrate.svg',
              width: 150,
            ),
            const Spacer(),
            CupertinoButton.filled(
              child: Text(AppLocalizations.of(context)!.qiblaWarnProceed),
              onPressed: () {
                GetStorage().write(kHasShowQiblaWarning, true);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    // no need route settings here, already defined in bottom
                    // ap bar icon
                    builder: (_) => const QiblaPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
