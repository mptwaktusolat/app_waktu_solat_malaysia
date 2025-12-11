import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../../../shared/constants/constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/models/location_coordinate_model.dart';
import '../../../../shared/services/location_service/location_database.dart';
import '../../../../providers/location_provider.dart';
import '../zone_chooser.dart';
import 'location_bubble_widget.dart';

class ZoneSuccessWidget extends StatelessWidget {
  const ZoneSuccessWidget({super.key, required this.coordinateData});

  final LocationCoordinateData coordinateData;

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (_, value, __) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                  child: Text(AppLocalizations.of(context)!.zoneYourLocation)),
            ),
            Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    coordinateData.lokasi!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.surfaceTint.withAlpha(26),
              ),
              child: ListTile(
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LocationBubbleWidget(
                      coordinateData.zone.toUpperCase(),
                      isSelected: true,
                    ),
                  ],
                ),
                title: Text(
                  LocationDatabase.daerah(coordinateData.zone),
                  style: const TextStyle(
                      fontSize: 13, height: 1.1, fontWeight: FontWeight.normal),
                ),
                subtitle: Text(
                  LocationDatabase.negeri(coordinateData.zone),
                  style: const TextStyle(fontSize: 11),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: OverflowBar(
                overflowAlignment: OverflowBarAlignment.end,
                children: [
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.zoneSetManually),
                    onPressed: () async {
                      await LocationChooser.openManualZoneSelector(context);
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.zoneSetThis),
                    onPressed: () {
                      value.currentLocationCode = coordinateData.zone;
                      LocationChooser.onNewLocationSaved(context);
                      GetStorage().write(kWidgetLocation,
                          coordinateData.lokasi ?? coordinateData.negeri);

                      Navigator.pop(context, true);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
