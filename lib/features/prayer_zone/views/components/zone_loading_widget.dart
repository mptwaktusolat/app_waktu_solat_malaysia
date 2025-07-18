import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../l10n/app_localizations.dart';

class ZoneLoadingWidget extends StatelessWidget {
  const ZoneLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.zoneLoading,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 24),
          SpinKitPulse(
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
