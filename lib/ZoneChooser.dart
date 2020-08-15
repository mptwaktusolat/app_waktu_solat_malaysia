import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waktusolatmalaysia/models/groupedzoneapi.dart';

String currentChoice;
String locationShortCode = '999';

class LocationChooser extends StatefulWidget {
  final GroupedZones zone;
  LocationChooser({Key key, this.zone}) : super(key: key);
  @override
  _LocationChooserState createState() => _LocationChooserState();
}

class _LocationChooserState extends State<LocationChooser> {
  final locationSnackbar = SnackBar(
    content: Text('Currently set to Puchong blexample'),
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: 'Change',
      onPressed: () {
        print('Pressed change loc');
      },
    ),
  );

  int selection = 0;

  //TODO: Remove duplicate in JSON
  //Linkkan dgn getprayertime

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.white),
      ),
      onPressed: () {
        print('Opened zone chooser');
        _openshowModalBottomSheet();
      },
      onLongPress: () {
        Scaffold.of(context).showSnackBar(locationSnackbar);
      },
      child: Row(
        children: [
          Text(
            locationShortCode.substring(0, 3) +
                ' ' +
                locationShortCode.substring(3, 5),
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
              color: Colors.white,
              fontSize: 15,
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
        });
    setState(() {
      print('It callled');
    });
  }
}

Widget locationBubble(String shortCode) {
  return Container(
    padding: EdgeInsets.all(4.0),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(16.0),
    ),
    child: Text(shortCode),
  );
}

class ZonesList extends StatelessWidget {
  final List<GroupedZones> groupedZones;
  ZonesList({Key key, this.groupedZones}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groupedZones == null ? 0 : groupedZones.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            currentChoice = groupedZones[index].zone;
            locationShortCode = currentChoice;
            Navigator.pop(context, index);
          },
          title: Text(groupedZones[index].lokasi),
          subtitle: Text(groupedZones[index].negeri),
          trailing: locationBubble(groupedZones[index].zone),
        );
      },
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
