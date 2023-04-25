import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' hide Location;
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../CONSTANTS.dart';
import '../location_utils/location_data.dart';
import '../location_utils/location_database.dart';
import '../location_utils/location_coordinate.dart';
import '../location_utils/location_coordinate_model.dart';
import '../providers/location_provider.dart';
import '../utils/debug_toast.dart';

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
    Placemark firstPlacemark;

    Position pos = await LocationData.getCurrentLocation();
    DebugToast.show(pos.toString());
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      firstPlacemark = placemarks.first;
    } on PlatformException catch (e) {
      if (e.message!.contains('A network error occurred')) {
        throw 'A network error occurred trying to lookup the supplied coordinates.';
      } else {
        rethrow;
      }
    }
    if (firstPlacemark.country!.toLowerCase() != "malaysia") {
      throw 'Outside Malaysia';
    }
    DebugToast.show(firstPlacemark.toString(), duration: Toast.LENGTH_LONG);
    var zone = LocationCoordinate.getJakimCodeNearby(
        pos.latitude, pos.longitude, firstPlacemark.administrativeArea);

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
    bool? res = await showDialog(
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
                  } else if (snapshot.hasError) {
                    return ZoneErrorWidget(
                        errorMessage: snapshot.error.toString());
                  } else {
                    return const ZoneErrorWidget(
                      errorMessage: 'Unexpected error occured',
                    );
                  }
                }),
          ),
        );
      },
    );
    return res ?? false;
  }

  static Future<bool?> openLocationBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Consumer<LocationProvider>(
          builder: (_, value, __) {
            return FractionallySizedBox(
              heightFactor: 0.68,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(26)),
                child: Container(
                  color: Theme.of(context).canvasColor,
                  child: Scrollbar(
                    child: ListView.builder(
                      itemCount: LocationDatabase.allLocation.length,
                      itemBuilder: (context, index) {
                        var element = LocationDatabase.allLocation[index];
                        bool selected =
                            value.currentLocationCode == element.jakimCode;

                        // Check if the current item is the first item in a new group
                        bool isFirstItemInGroup = index == 0 ||
                            element.negeri !=
                                LocationDatabase.allLocation[index - 1].negeri;

                        // If it's the first item in a group, create a header item
                        if (isFirstItemInGroup) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                child: Text(
                                  element.negeri,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  value.currentLocationCode = element.jakimCode;
                                  onNewLocationSaved(context);
                                  Navigator.pop(context, true);
                                },
                                title: Text(
                                    LocationDatabase.daerah(element.jakimCode)),
                                trailing: LocationBubble(element.jakimCode,
                                    selected: selected),
                                selected: selected,
                              ),
                            ],
                          );
                        }

                        // If it's not the first item in a group, create a child item
                        return ListTile(
                          onTap: () {
                            value.currentLocationCode = element.jakimCode;
                            onNewLocationSaved(context);
                            Navigator.pop(context, true);
                          },
                          title:
                              Text(LocationDatabase.daerah(element.jakimCode)),
                          trailing: LocationBubble(element.jakimCode,
                              selected: selected),
                          selected: selected,
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class LocationBubble extends StatelessWidget {
  const LocationBubble(this.shortCode, {Key? key, this.selected = false})
      : super(key: key);

  final bool selected;
  final String shortCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: selected ? Theme.of(context).colorScheme.primary : null,
        border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        shortCode,
        style: selected ? const TextStyle(color: Colors.white) : null,
      ),
    );
  }
}

class ZoneSuccessWidget extends StatelessWidget {
  const ZoneSuccessWidget({Key? key, required this.coordinateData})
      : super(key: key);

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
                    LocationBubble(coordinateData.zone.toUpperCase()),
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
                      bool res = await LocationChooser.openLocationBottomSheet(
                              context) ??
                          false;
                      Navigator.pop(context, res);
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.zoneSetThis),
                    onPressed: () {
                      value.currentLocationCode = coordinateData.zone;
                      LocationChooser.onNewLocationSaved(context);

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

class ZoneLoadingWidget extends StatelessWidget {
  const ZoneLoadingWidget({Key? key}) : super(key: key);

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

class ZoneErrorWidget extends StatelessWidget {
  const ZoneErrorWidget({Key? key, required this.errorMessage})
      : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Center(
                child: Text(AppLocalizations.of(context)!.zoneError),
              )),
          Expanded(
            flex: 3,
            child: DefaultTextStyle(
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.fmd_bad_outlined,
                        size: 40,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      Icon(
                        Icons
                            .signal_cellular_connected_no_internet_0_bar_outlined,
                        size: 40,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ],
                  ),
                  MarkdownBody(
                    data: AppLocalizations.of(context)!.zoneErrorPara1,
                    styleSheet: MarkdownStyleSheet(
                        textAlign: WrapAlignment.center,
                        p: TextStyle(
                            color: Theme.of(context).colorScheme.error)),
                  ),
                  const SizedBox(height: 10),
                  MarkdownBody(
                    data: AppLocalizations.of(context)!.zoneErrorPara2,
                    styleSheet: MarkdownStyleSheet(
                      textAlign: WrapAlignment.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async =>
                      await AppSettings.openLocationSettings(),
                  child: Text(
                    AppLocalizations.of(context)!.zoneOpenLocationSettings,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    bool res = await LocationChooser.openLocationBottomSheet(
                            context) ??
                        false;
                    Navigator.pop(context, res);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.zoneSetManually,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
