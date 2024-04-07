import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoCompassSensor extends StatelessWidget {
  const NoCompassSensor({super.key});

  @override
  Widget build(BuildContext context) {
    const box = SizedBox(height: 32);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.explore_off_outlined,
            size: 130,
            color: Colors.redAccent,
          ),
          box,
          Text(
            AppLocalizations.of(context)!.qiblaErrNoCompass,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          box,
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.qiblaErrBack,
            ),
          )
        ],
      ),
    );
  }
}
