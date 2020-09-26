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
import 'package:waktusolatmalaysia/utils/restartWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waktusolatmalaysia/models/groupedzoneapi.dart';

String locationShortCode;
String currentlySetNegeri;
String currentlySetKawasan;
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
    GetStorage().writeIfNull(kStoredGlobalIndex, 1);
    globalIndex = GetStorage().read(kStoredGlobalIndex);
  }

  @override
  Widget build(BuildContext context) {
    var shortCode = locationDatabase.getJakimCode(globalIndex);
    print(shortCode);
    return FlatButton(
      padding: EdgeInsets.all(-5.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.white),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => GetGPS(),
        );
        print('Opened zone chooser');

        // openshowModalBottomSheet(context);
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
              openshowModalBottomSheet(context);
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

Future openshowModalBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.68,
          child: ZonesList(),
        );
      }).then((value) {
    Future.delayed(const Duration(milliseconds: 450), () {
      RestartWidget.restartApp(context);
    });
  });
  // setState(() {
  //   RestartWidget.restartApp(context);
  // });
}

Widget locationBubble(String shortCode) {
  return Container(
    padding: EdgeInsets.all(4.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Text(
      shortCode,
    ),
  );
}

class ZonesList extends StatelessWidget {
  ZonesList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26.0), topRight: Radius.circular(26.0)),
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: locationDatabase.getLocationDatabaseLength(),
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                GetStorage().write(kStoredGlobalIndex, index);
                print('Index inside modal bottom sheet is $index');
                print('GetStorage is ${GetStorage().read(kStoredGlobalIndex)}');
                Navigator.pop(context, index);
              },
              title: Text(locationDatabase.getDaerah(index)),
              subtitle: Text(locationDatabase.getNegeri(index)),
              trailing: locationBubble(locationDatabase.getJakimCode(index)),
            );
          },
        ),
      ),
    );
  }
}

class GetGPS extends StatefulWidget {
  @override
  _GetGPSState createState() => _GetGPSState();
}

class _GetGPSState extends State<GetGPS> {
  Mpti906Bloc _mpti906bloc;

  @override
  void initState() {
    super.initState();
    print('${LocationData.latitude}, ${LocationData.longitude}');
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
                  case Status.LOADING:
                    return Loading(
                      loadingMessage: 'Getting location',
                    );
                  case Status.COMPLETED:
                    return Completed(
                      jakimCode: snapshot.data.data.data.attributes.jakimCode,
                      place: snapshot.data.data.data.place,
                    );
                    break;
                  case Status.ERROR:
                    print('has error');
                    return Error(
                        errorMessage: snapshot.data.message,
                        onRetryPressed: () {
                          Fluttertoast.showToast(
                              msg:
                                  'Failed to get GPS data. Fallback to manual selection');
                          openshowModalBottomSheet(context);
                        });
                    break;
                }
              }
              return Container(
                child: Text('snapshot empty'),
              );
            },
          ),
        ));
  }

  @override
  void dispose() {
    _mpti906bloc.dispose();
    super.dispose();
  }

  void getLocation() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

    print(position);
  }
}

//////////////////////////
class Completed extends StatelessWidget {
  Completed({this.jakimCode, this.place});
  final String jakimCode;
  final String place;
  @override
  Widget build(BuildContext context) {
    var index = locationDatabase.indexOfLocation(jakimCode);
    globalIndex = index;
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
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
            )),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.teal.shade50),
          child: ListTile(
            leading: locationBubble(
              jakimCode.substring(0, 3).toUpperCase() +
                  ' ' +
                  jakimCode.substring(3, 5),
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
                FlatButton(
                  // color: Colors.teal[50],
                  child: Text(
                    'Set manually',
                    style: TextStyle(color: Colors.teal.shade800),
                  ),
                  onPressed: () => openshowModalBottomSheet(context),
                ),
                FlatButton(
                  // color: Colors.teal[50],
                  child: Text(
                    'Accept this location',
                    style: TextStyle(color: Colors.teal.shade800),
                  ),
                  onPressed: () {
                    // globalIndex = index;
                    GetStorage().write(kStoredGlobalIndex, index);
                    RestartWidget.restartApp(context);
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

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(errorMessage);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.white,
            child: Text('Retry', style: TextStyle(color: Colors.black)),
            onPressed: onRetryPressed,
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
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          // CircularProgressIndicator(
          //   valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade900),
          // ),
          SpinKitPulse(
            color: Colors.teal,
          )
        ],
      ),
    );
  }
}
