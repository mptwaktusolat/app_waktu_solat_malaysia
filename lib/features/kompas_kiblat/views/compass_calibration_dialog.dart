import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../l10n/app_localizations.dart';

Future<void> showCompassCalibrationDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) {
      final localizations = AppLocalizations.of(context)!;
      return AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        title: Text(
          localizations.qiblaCalibrate,
          textAlign: TextAlign.center,
        ),
        content: SvgPicture.asset(
          'assets/qibla/compass callibrate.svg',
          height: 230,
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.qiblaCalibrateDone),
          ),
        ],
      );
    },
  );
}
