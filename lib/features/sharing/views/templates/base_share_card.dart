import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../providers/location_provider.dart';
import '../../../../shared/extensions/date_time_extensions.dart';
import '../../../../utils/prayer_data_handler.dart';

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
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat.yMMMMEEEEd(
      Localizations.localeOf(context).languageCode,
    ).format(now);
    final String location =
        Provider.of<LocationProvider>(context, listen: false)
            .currentLocationCode;
    final today = PrayDataHandler.today();
    final Map<String, String> prayerTimes = {
      AppLocalizations.of(context)!.fajrName: today.fajr.readable(true),
      AppLocalizations.of(context)!.dhuhrName: today.dhuhr.readable(true),
      AppLocalizations.of(context)!.asrName: today.asr.readable(true),
      AppLocalizations.of(context)!.maghribName: today.maghrib.readable(true),
      AppLocalizations.of(context)!.ishaName: today.isha.readable(true),
    };

    return Material(
      child: buildCardContent(
        context,
        formattedDate: formattedDate,
        location: location,
        prayerTimes: prayerTimes,
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
          height: 24,
          width: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          AppLocalizations.of(context)!.appTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
