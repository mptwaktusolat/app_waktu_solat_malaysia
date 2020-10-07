//This widget is rendered as Location button at header part

import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/blocs/mpti906_bloc.dart';
import 'package:waktusolatmalaysia/models/mpti906api.dart';
import 'package:waktusolatmalaysia/networking/Response.dart';
import 'package:waktusolatmalaysia/utils/LocationData.dart';
import 'package:waktusolatmalaysia/utils/location/locationDatabase.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waktusolatmalaysia/models/groupedzoneapi.dart';
import 'package:waktusolatmalaysia/views/GetPrayerTime.dart';

int globalIndex;

LocationDatabase locationDatabase = LocationDatabase();

class LocationChooser extends StatefulWidget {
  final GroupedZones zone;
  LocationChooser({Key key, this.zone}) : super(key: key);

  @override
  _LocationChooserState createState() => _LocationChooserState();
}

class _LocationChooserState extends State<LocationChooser> {
  @override
  void initState() {
    super.initState();
    GetStorage().writeIfNull(kStoredGlobalIndex,
        0); //null when first run, defaulted to JHR 01 (top of the list)
    globalIndex = GetStorage().read(kStoredGlobalIndex);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //if first run, then promote to change location
      if (GetStorage().read(kStoredFirstRun)) {
        GetStorage().write(kStoredFirstRun, false);
        return Scaffold.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
                'Please update your location (if necessary) by tapping JHR 01 button above'),
            duration: Duration(seconds: 6),
            action: SnackBarAction(
              label: 'Got it!',
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });

    var shortCode = locationDatabase.getJakimCode(globalIndex);

    void _updateUI() {
      //this setState will be called when user select a new location, this will update the Text short code
      setState(() {
        shortCode = locationDatabase.getJakimCode(globalIndex);
      });
    }

    return FlatButton(
      padding: EdgeInsets.all(-5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.white),
      ),
      onPressed: () async {
        LocationPermission permission = await checkPermission();
        if (permission == LocationPermission.deniedForever) {
          //if deniedForever, it will skip the GPS methof
          openshowModalBottomSheet(context, _updateUI);
        } else {
          showDialog(
            context: context,
            builder: (context) => GetGPS(_updateUI),
          );
        }
      },
      onLongPress: () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Currently set to ${locationDatabase.getDaerah(globalIndex)} in ${locationDatabase.getNegeri(globalIndex)}'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Change',
            onPressed: () {
              print('Pressed change loc');
              openshowModalBottomSheet(context, _updateUI);
            },
          ),
        ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: Colors.teal.shade50,
            size: 17,
          ),
          Text(
            '  ' +
                shortCode.substring(0, 3).toUpperCase() +
                ' ' +
                shortCode.substring(3, 5),
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
              color: Colors.white,
              fontSize: 13,
            )),
          ),
        ],
      ),
    );
  }
}

Future openshowModalBottomSheet(BuildContext context, Function callback) async {
  print(globalIndex);
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.68,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26.0),
                topRight: Radius.circular(26.0)),
            child: Container(
              color: Theme.of(context).canvasColor,
              child: ListView.builder(
                itemCount: locationDatabase.getLocationDatabaseLength(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      GetStorage().write(kStoredGlobalIndex, index);
                      Navigator.pop(context,
                          index); //index param here will pass as selectedindex below
                    },
                    title: Text(locationDatabase.getDaerah(index)),
                    subtitle: Text(locationDatabase.getNegeri(index)),
                    trailing: locationBubble(
                        context, locationDatabase.getJakimCode(index)),
                    selected: globalIndex == index ? true : false,
                  );
                },
              ),
            ),
          ),
        );
      }).then((selectedIndex) {
    /*
      SelectedIndex is location index coming from Navigator.pop()
      app should restart when index changed
      when user close bottom sheet without selecting location, selectedIndex simply return null 
      */
    print('selectedIndex is $selectedIndex and globalIndex is $globalIndex');
    if (selectedIndex != globalIndex) {
      if (selectedIndex != null) {
        globalIndex = selectedIndex;
        Fluttertoast.showToast(msg: 'Location updated and saved');
        // RestartWidget.restartApp(context);
        callback();
        GetPrayerTime.updateUI(locationDatabase.getJakimCode(selectedIndex));
      }
    }
  });
}

Widget locationBubble(BuildContext context, String shortCode) {
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

class GetGPS extends StatefulWidget {
  GetGPS(this.callback);
  final Function callback;
  @override
  _GetGPSState createState() => _GetGPSState();
}

class _GetGPSState extends State<GetGPS> {
  Mpti906Bloc _mpti906bloc;
  // LocationData.getCurrentLocation();

  @override
  void initState() {
    super.initState();
    _mpti906bloc = Mpti906Bloc(LocationData.latitude, LocationData.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 16, 8, 4),
        height: 250,
        child: StreamBuilder<Response<Mpti906>>(
          stream: _mpti906bloc.mptDataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('mpt snapshot hasData');
              switch (snapshot.data.status) {
                // switch (Status.ERROR) {
                case Status.LOADING:
                  return Loading(
                    loadingMessage: 'Getting location',
                  );
                //TODO: timeup bila failed fetch location, show manual method instead
                case Status.COMPLETED:
                  return Completed(
                    jakimCode: snapshot.data.data.data.attributes.jakimCode,
                    place: snapshot.data.data.data.place,
                    onCallback: widget.callback,
                  );
                  break;
                case Status.ERROR:
                  print('has error');
                  return Error(
                      errorMessage: snapshot.data.message,
                      onRetryPressed: () => _mpti906bloc.fetchLocationData(
                          LocationData.latitude, LocationData.longitude));
                  break;
              }
            }
            return Container(
              child: Text('snapshot empty'),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    LocationData
        .getCurrentLocation(); //refresh new gps data (if available), if not available, previously set data is still there
    _mpti906bloc.dispose();
    super.dispose();
  }
}

/////////////////////////////////////////////////////////////////////
class Completed extends StatelessWidget {
  Completed({this.jakimCode, this.place, this.onCallback});
  final String jakimCode;
  final String place;
  final Function onCallback;
  @override
  Widget build(BuildContext context) {
    var index = locationDatabase.indexOfLocation(jakimCode);

    print('detected index is $index');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Your location'),
          ),
        ),
        Expanded(
            flex: 3,
            child: Center(
              child: Text(
                place,
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
                locationBubble(context, jakimCode.toUpperCase()),
              ],
            ),
            title: Text(
              locationDatabase.getDaerah(index),
              style: TextStyle(fontSize: 13),
            ),
            subtitle: Text(
              locationDatabase.getNegeri(index),
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
                  onPressed: () {
                    Navigator.pop(context);
                    openshowModalBottomSheet(context, onCallback);
                  },
                ),
                TextButton(
                  child: Text(
                    'Accept this location',
                  ),
                  onPressed: () {
                    GetStorage().write(kStoredGlobalIndex, index);
                    globalIndex = index;
                    Fluttertoast.showToast(msg: 'Location updated and saved');
                    onCallback();
                    Navigator.pop(context);
                    GetPrayerTime.updateUI(jakimCode); //refresh prayer time
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  final Function callback;

  const Error({Key key, this.errorMessage, this.onRetryPressed, this.callback})
      : super(key: key);

  //show error according to condition, eg if no gps, no internet

  @override
  Widget build(BuildContext context) {
    print(errorMessage);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Text(
                'Error',
              )),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      // color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Tap '),
                      TextSpan(
                        text: 'retry',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                              ', or try closing this dialog and open it back.'),
                    ],
                  ),
                ),
                Spacer(),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      // color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'If it didn\'t work, please '),
                      TextSpan(
                        text: 'set your location manually.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 12, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(text: 'Make sure your '),
                      TextSpan(
                        text: 'GPS turned on, ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: 'then restart this app.'),
                    ],
                  ),
                ),
                Spacer(),
              ],
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
                    fontSize: 9,
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
                    onPressed: () {
                      openshowModalBottomSheet(context, callback);
                    },
                    child: Text(
                      'Set manually',
                      // style: TextStyle(color: Colors.teal.shade800),
                    )),
                TextButton(
                  onPressed: onRetryPressed,
                  child: Text(
                    'Retry',
                    // style: TextStyle(color: Colors.teal.shade800),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
