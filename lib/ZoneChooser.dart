import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:waktusolatmalaysia/blocs/zone_bloc.dart';
import 'package:waktusolatmalaysia/models/groupedzoneapi.dart';

import 'networking/Response.dart';

//TODO: Make sure this things works

class GetGroupedZone extends StatefulWidget {
  @override
  _GetGroupedZoneState createState() => _GetGroupedZoneState();
}

class _GetGroupedZoneState extends State<GetGroupedZone> {
  ZoneBloc _zoneBloc;

  void initState() {
    _zoneBloc = ZoneBloc();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response<GroupedZones>>(
      stream: _zoneBloc.zoneDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(loadingMessage: snapshot.data.message);
              break;
            case Status.COMPLETED:
              return LocationChooser(zone: snapshot.data.data);
              break;
            case Status.ERROR:
              return Error(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => _zoneBloc.fetchZone(),
              );
              break;
          }
        }
        return Container();
      },
    );
  }
}

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
  String locationShortCode = 'SGR 01';

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
            locationShortCode,
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
    final option = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 0.68,
            child: ListView(
              children: List.generate(40, (index) {
                return ListTile(
                  title: Text('0'),
                  subtitle: Text('Hai saya $index'),
                  trailing: locationBubble('SGR $index'),
                  onTap: () {
                    Navigator.pop(context, index);
                  },
                );
              }),
            ),
          );
        });
    setState(() {
      selection = option;
      print('Selection is $selection, option is $option');
      locationShortCode = 'SGR $option';
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

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade900),
          ),
        ],
      ),
    );
  }
}
