import 'dart:async';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/utils/restartWidget.dart';

import 'GetPrayerTime.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waktusolatmalaysia/models/groupedzoneapi.dart';

String locationShortCode = GetStorage().read(kStoredLocationKey);
String currentlySetNegeri = '';
String currentlySetKawasan = '';

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
    currentlySetNegeri = GetStorage().read(kStoredNegeriKey);
    currentlySetKawasan = GetStorage().read(kStoredKawasanKey);
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
        print('Opened zone chooser');
        _openshowModalBottomSheet();
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
              _openshowModalBottomSheet();
            },
          ),
        ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            locationShortCode.substring(0, 3).toUpperCase() +
                ' ' +
                locationShortCode.substring(3, 5),
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
              color: Colors.white,
              fontSize: 13,
            )),
          ),
          Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          )
        ],
      ),
    );
  }

  Future _openshowModalBottomSheet() async {
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
