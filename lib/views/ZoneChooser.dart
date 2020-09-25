import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/blocs/mpti906_bloc.dart';
import 'package:waktusolatmalaysia/models/mpti906api.dart';
import 'package:waktusolatmalaysia/networking/Response.dart';
import 'package:waktusolatmalaysia/utils/LocationData.dart';
import 'package:waktusolatmalaysia/utils/restartWidget.dart';

import '../main.dart';
import 'GetPrayerTime.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waktusolatmalaysia/models/groupedzoneapi.dart';

String locationShortCode;
String currentlySetNegeri;
String currentlySetKawasan;

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

    GetStorage().writeIfNull(kStoredLocationKey, "sgr01");
    GetStorage().writeIfNull(kStoredKawasanKey,
        "Gombak, Hulu Selangor, Rawang, Hulu Langat, Sepang, Petaling, Shah Alam");
    GetStorage().writeIfNull(kStoredNegeriKey, "Selangor");
    currentlySetNegeri = GetStorage().read(kStoredNegeriKey);
    currentlySetKawasan = GetStorage().read(kStoredKawasanKey);
    locationShortCode = GetStorage().read(kStoredLocationKey);
  }

  @override
  Widget build(BuildContext context) {
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

        // _openshowModalBottomSheet();
      },
      onLongPress: () {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              'Currently set to $currentlySetKawasan in $currentlySetNegeri'),
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
                locationShortCode.substring(0, 3).toUpperCase() +
                ' ' +
                locationShortCode.substring(3, 5),
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
          child: FutureBuilder(
              future: DefaultAssetBundle.of(context)
                  .loadString('assets/grouped.json'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ZonesList(
                    groupedZones: parseJson(snapshot.data),
                  );
                } else if (snapshot.hasError) {
                  return Text('Snapshot has error');
                } else {
                  return CircularProgressIndicator();
                }
              }),
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
  final List<GroupedZones> groupedZones;
  ZonesList({Key key, this.groupedZones}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26.0), topRight: Radius.circular(26.0)),
      child: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: groupedZones == null ? 0 : groupedZones.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                locationShortCode = groupedZones[index].zone;
                currentlySetKawasan = groupedZones[index].lokasi;
                currentlySetNegeri = groupedZones[index].negeri;
                location = locationShortCode;
                saveToGetStorage(
                    shortCode: locationShortCode,
                    kawasan: currentlySetKawasan,
                    negeri: currentlySetNegeri);
                Navigator.pop(context, index);

                print(index);
              },
              title: Text(groupedZones[index].lokasi),
              subtitle: Text(groupedZones[index].negeri),
              trailing: locationBubble(groupedZones[index].zone),
            );
          },
        ),
      ),
    );
  }
}

List<GroupedZones> parseJson(String response) {
  if (response == null) {
    return [];
  }
  final parsed = json.decode(response.toString()).cast<Map<String, dynamic>>();
  return parsed
      .map<GroupedZones>((json) => GroupedZones.fromJson(json))
      .toList();
}

void saveToGetStorage({String shortCode, String kawasan, String negeri}) {
  GetStorage().write(kStoredLocationKey, shortCode);
  GetStorage().write(kStoredKawasanKey, kawasan);
  GetStorage().write(kStoredNegeriKey, negeri);
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            flex: 1,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: locationBubble(
                  jakimCode.substring(0, 3).toUpperCase() +
                      ' ' +
                      jakimCode.substring(3, 5),
                ))),
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              place,
              style: TextStyle(fontSize: 20),
            ),
          ),
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
                    locationShortCode = jakimCode.toUpperCase();
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
