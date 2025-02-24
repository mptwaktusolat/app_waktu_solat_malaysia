import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../providers/location_provider.dart';
import '../../../../shared/extensions/date_time_extensions.dart';
import '../../../../utils/prayer_data_handler.dart';

class ShareCard1 extends StatelessWidget {
  const ShareCard1({super.key, this.repaintBoundaryKey});

  final GlobalKey? repaintBoundaryKey;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(now);
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formattedDate,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              location,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...prayerTimes.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      entry.value,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }),
            Spacer(),
            Center(
              child: Text(
                'Waktu Solat Malaysia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
