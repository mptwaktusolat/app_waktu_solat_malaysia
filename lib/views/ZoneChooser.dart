///This widget is rendered as Location button at header part.
///Also handle the location selection
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/locationUtil/LocationData.dart';
import 'package:geocoding/geocoding.dart';
import 'package:waktusolatmalaysia/locationUtil/locationDatabase.dart';
import 'package:waktusolatmalaysia/locationUtil/location_coordinate.dart';
import 'package:waktusolatmalaysia/locationUtil/location_coordinate_model.dart';
import 'package:waktusolatmalaysia/locationUtil/location_provider.dart';

class LocationChooser {
  static void onNewLocationSaved(BuildContext context) {
    GetStorage().write(kStoredShouldUpdateNotif,
        true); //if zone changes, update the notification
    //this setState will be called when user select a new location, this will update the Text short code
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 2500),
        content: Row(
          children: [
            Icon(
              Icons.pin_drop_rounded,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black87
                  : Colors.white70,
            ),
            SizedBox(
              width: 10,
            ),
            Text('Updated and saved'),
          ],
        ),
      ),
    );
  }

  static Future<LocationCoordinateData> _getAllLocationData() async {
    var administrativeArea;
    var locality;

    Position _pos = await LocationData.getCurrentLocation();

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(_pos.latitude, _pos.longitude);
      var first = placemarks.first;
      print(first);

      print(
          '[_getAllLocationData] ${first.locality}, ${first.administrativeArea}');
      administrativeArea = first.administrativeArea;
      locality = first.locality;
      GetStorage().write(kStoredLocationLocality, locality);
    } catch (e) {
      print('[_getAllLocationData] Error: $e');
      GetStorage().write(kStoredLocationLocality, e.toString());
      Fluttertoast.showToast(
          msg: 'Error $e occured. Sorry', backgroundColor: Colors.red);
      throw e;
    }

    var zone = LocationCoordinate.getJakimCodeNearby(
        LocationData.latitude, LocationData.longitude, administrativeArea);

    return LocationCoordinateData(
        zone: zone,
        negeri: administrativeArea,
        lokasi: locality,
        lat: null,
        lng: null);
  }

  static Future<bool> showLocationChooser(BuildContext context) async {
    bool res = await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(8, 16, 8, 4),
            height: 250,
            child: FutureBuilder(
                future: _getAllLocationData().timeout(Duration(seconds: 10)),
                builder:
                    (context, AsyncSnapshot<LocationCoordinateData> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return onLoadingWidget();
                  } else if (snapshot.hasData) {
                    return onCompletedWidget(context, location: snapshot.data);
                  } else if (snapshot.hasError) {
                    return onErrorWidget(
                      context,
                      errorMessage: snapshot.error.toString(),
                    );
                  } else {
                    return onErrorWidget(context,
                        errorMessage: 'Unexpected error occured');
                  }
                }),
          ),
        );
      },
    );
    return res ?? false;
  }

  static Future<bool> openLocationBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Consumer<LocationProvider>(
            builder: (context, value, child) {
              return FractionallySizedBox(
                heightFactor: 0.68,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26.0),
                      topRight: Radius.circular(26.0)),
                  child: Container(
                    color: Theme.of(context).canvasColor,
                    child: Scrollbar(
                      child: ListView.builder(
                        itemCount: LocationDatabase.getLength(),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              bool _success = false;

                              if (index != null) {
                                value.currentLocationIndex = index;
                                _success = true;
                                onNewLocationSaved(context);
                              }
                              Navigator.pop(context, _success);
                            },
                            title: Text(LocationDatabase.getDaerah(index)),
                            subtitle: Text(LocationDatabase.getNegeri(index)),
                            trailing: locationBubble(
                                context, LocationDatabase.getJakimCode(index)),
                            selected:
                                GetStorage().read(kStoredGlobalIndex) == index
                                    ? true
                                    : false,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  static Widget locationBubble(BuildContext context, String shortCode) {
    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        shortCode,
      ),
    );
  }

  static Widget onCompletedWidget(BuildContext context,
      {@required LocationCoordinateData location}) {
    var index = LocationDatabase.indexOfLocation(location.zone);

    print('detected index is $index');
    return Consumer<LocationProvider>(
      builder: (context, value, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: Center(child: Text('Your location')),
            ),
            Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    location.lokasi,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                )),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).bottomAppBarColor,
              ),
              child: ListTile(
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    locationBubble(context, location.zone.toUpperCase()),
                  ],
                ),
                title: Text(
                  LocationDatabase.getDaerah(index),
                  style: TextStyle(fontSize: 13),
                ),
                subtitle: Text(
                  LocationDatabase.getNegeri(index),
                  style: TextStyle(fontSize: 11),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      child: Text(
                        'Set manually',
                      ),
                      onPressed: () async {
                        bool res =
                            await openLocationBottomSheet(context) ?? false;
                        Navigator.pop(context, res);
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Set this location',
                      ),
                      onPressed: () {
                        value.currentLocationIndex = index;
                        onNewLocationSaved(context);

                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget onErrorWidget(BuildContext context,
      {@required String errorMessage, Function onRetryPressed}) {
    print(errorMessage);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Center(
                child: Text('Error'),
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
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Please make sure your '),
                        TextSpan(
                          text: 'GPS is turned on.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('\nYou can try the following:'),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Try closing'),
                        TextSpan(
                          text: ' this ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: 'dialog and open it back, or'),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(text: 'Set your location'),
                        TextSpan(
                          text: ' manually.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () async {
                      bool res =
                          await openLocationBottomSheet(context) ?? false;
                      Navigator.pop(context, res);
                    },
                    child: Text(
                      'Set manually',
                      // style: TextStyle(color: Colors.teal.shade800),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  static Widget onLoadingWidget({String loadingMessage = 'Loading'}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          SpinKitPulse(
            color: Colors.teal,
          )
        ],
      ),
    );
  }
}
