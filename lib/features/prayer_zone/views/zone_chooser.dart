import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../../../shared/constants/constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../location_utils/location_coordinate_model.dart';
import '../../../location_utils/location_data.dart';
import '../../../providers/location_provider.dart';
import '../../../shared/models/jakim_zones.dart';
import 'components/zone_error_widget.dart';
import 'components/zone_loading_widget.dart';
import 'components/zone_success_widget.dart';
import 'zone_list_page.dart';

///This widget is rendered as Location button at header part.
///Also handle the location selection
class LocationChooser {
  static void onNewLocationSaved(BuildContext context) {
    GetStorage().write(
        kShouldUpdateNotif, true); //if zone changes, update the notification
    //this setState will be called when user select a new location, this will
    //update the Text short code
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1300),
        content: Row(
          children: [
            Icon(
              Icons.pin_drop_rounded,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black87
                  : Colors.white70,
            ),
            const SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.zoneUpdatedToast),
          ],
        ),
      ),
    );
  }

  static Future<LocationCoordinateData> _getAllLocationData() async {
    final Position pos = await LocationData.getCurrentLocation();

    final Future<List<Placemark>> placemarksFuture =
        placemarkFromCoordinates(pos.latitude, pos.longitude);
    final Future<MptZoneByGPS> jakimZoneFuture =
        WaktuSolat.getZoneByCoordinates(pos.latitude, pos.longitude);
    final (placemarks, jakimZone) =
        await (placemarksFuture, jakimZoneFuture).wait;

    final firstPlacemark = placemarks.first;
    final String zone = jakimZone.zone;

    // for [lokasi], the priority us `subLocality`. If empty, `locality`.
    // If empty, fallback to `name`.
    return LocationCoordinateData(
        zone: zone,
        negeri: firstPlacemark.administrativeArea,
        lokasi: firstPlacemark.subLocality!.isNotEmpty
            ? firstPlacemark.subLocality
            : firstPlacemark.locality!.isNotEmpty
                ? firstPlacemark.locality
                : firstPlacemark.name,
        lat: null,
        lng: null);
  }

  static Future<bool> showLocationChooser(BuildContext context) async {
    final bool? res = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 4),
            height: 250,
            child: FutureBuilder(
                future:
                    _getAllLocationData().timeout(const Duration(seconds: 12)),
                builder: (_, AsyncSnapshot<LocationCoordinateData> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ZoneLoadingWidget();
                  } else if (snapshot.hasData) {
                    return ZoneSuccessWidget(coordinateData: snapshot.data!);
                  } else {
                    return const ZoneErrorWidget();
                  }
                }),
          ),
        );
      },
    );
    return res ?? false;
  }

  static Future<void> openManualZoneSelector(BuildContext context) async {
    final JakimZones? newZone =
        await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const ZoneListPage();
    }));

    if (newZone == null) return;

    Provider.of<LocationProvider>(context, listen: false).currentLocationCode =
        newZone.jakimCode;
    onNewLocationSaved(context);
    GetStorage().write(kWidgetLocation, newZone.daerah);
  }
}
