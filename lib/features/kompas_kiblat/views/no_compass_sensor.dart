import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class NoCompassSensor extends StatelessWidget {
  const NoCompassSensor({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.explore_off_outlined,
            size: 88,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.qiblaErrNoCompass,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
