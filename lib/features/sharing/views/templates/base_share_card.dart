import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../providers/location_provider.dart';
import '../../../../shared/extensions/date_time_extensions.dart';
import '../../../../shared/services/location_service/location_database.dart';
import '../../../prayer_time/providers/prayer_time_provider.dart';

/// A base class for share card widgets that can be captured as images.
///
/// This abstract class serves as a foundation for creating various share card designs
/// that can be converted into images for sharing purposes.
///
/// The [repaintBoundaryKey] is used to identify the widget boundary for image capture.
/// It should be assigned to a [RepaintBoundary] widget in the implementing class.
///
/// Subclasses must implement the [buildCardContent] method to define the card's visual appearance.
abstract class BaseShareCard extends StatelessWidget {
  const BaseShareCard({super.key, this.repaintBoundaryKey});

  final GlobalKey? repaintBoundaryKey;

  @protected
  Widget buildCardContent(
    BuildContext context, {
    required String formattedDate,
    required String location,
    required Map<String, String> prayerTimes,
    required HijriDate hijriDate,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).languageCode,
    ).format(now);
    final String currentJakimCode =
        Provider.of<LocationProvider>(context, listen: false)
            .currentLocationCode;
    final String locationDetail = LocationDatabase.daerah(currentJakimCode);

    final today = Provider.of<PrayerTimeProvider>(context, listen: false)
        .getTodayPrayer();

    if (today == null) {
      return const SizedBox.shrink();
    }

    final Map<String, String> prayerTimes = {
      AppLocalizations.of(context)!.fajrName: today.fajr.readable(true),
      AppLocalizations.of(context)!.dhuhrName: today.dhuhr.readable(true),
      AppLocalizations.of(context)!.asrName: today.asr.readable(true),
      AppLocalizations.of(context)!.maghribName: today.maghrib.readable(true),
      AppLocalizations.of(context)!.ishaName: today.isha.readable(true),
    };

    final hijriDate = today.hijri;

    return Material(
      child: buildCardContent(
        context,
        formattedDate: formattedDate,
        location: '$currentJakimCode - $locationDetail',
        prayerTimes: prayerTimes,
        hijriDate: hijriDate,
      ),
    );
  }

  @protected
  Widget buildAppLogo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/app-logo-minimal-50w.png',
          height: 12,
          width: 12,
          color: Colors.white.withAlpha(200),
        ),
        const SizedBox(width: 4),
        Text(
          AppLocalizations.of(context)!.appTitle,
          style: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white.withAlpha(200),
          ),
        ),
      ],
    );
  }
}
