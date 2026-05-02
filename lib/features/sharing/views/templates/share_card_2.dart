import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../../../../l10n/app_localizations.dart';
import 'base_share_card.dart';

class ShareCard2 extends BaseShareCard {
  const ShareCard2({super.key, super.repaintBoundaryKey});

  @override
  Widget buildAppLogo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/app-logo-minimal-50w.png',
          height: 20,
          width: 20,
          color: Colors.teal,
        ),
        const SizedBox(width: 4),
        Text(
          AppLocalizations.of(context)!.appTitle,
          style: GoogleFonts.dmSerifText(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }

  @override
  Widget buildCardContent(
    BuildContext context, {
    required String formattedDate,
    required String location,
    required Map<String, String> prayerTimes,
    required HijriDate hijriDate,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: buildAppLogo(context)),
          const Divider(thickness: 2),
          const SizedBox(height: 10),
          Text(
            formattedDate,
            style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            location,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 20),
          ...prayerTimes.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
