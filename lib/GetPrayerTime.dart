import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/blocs/azan_times_today_bloc.dart';
import 'package:waktusolatmalaysia/models/azanproapi.dart';
import 'main.dart';

import 'networking/Response.dart';

String location = "sgr01";

class GetPrayerTime extends StatefulWidget {
  @override
  _GetPrayerTimeState createState() => _GetPrayerTimeState();
}

class _GetPrayerTimeState extends State<GetPrayerTime> {
  PrayTimeBloc _timeBloc;

  String timeFormat = "&format=12-hour";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en_US', null);
    _timeBloc = PrayTimeBloc(location, timeFormat);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response<PrayerTime>>(
      stream: _timeBloc.prayDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(loadingMessage: snapshot.data.message);
              break;
            case Status.COMPLETED:
              // Fluttertoast.showToast(
              //     msg: 'Updated just now',
              //     backgroundColor: Colors.black12,
              //     textColor: Colors.white);
              return PrayTimeList(prayerTime: snapshot.data.data);
              break;
            case Status.ERROR:
              return Error(
                errorMessage: snapshot.data.message,
                onRetryPressed: () =>
                    _timeBloc.fetchPrayerTime(location, timeFormat),
              );
              break;
          }
        }
        return Container();
      },
    );
  }

  @override
  void dispose() {
    _timeBloc.dispose();
    super.dispose();
  }
}

class PrayTimeList extends StatelessWidget {
  final PrayerTime prayerTime;

  const PrayTimeList({Key key, this.prayerTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        solatCard(prayerTime.prayerTimes.subuh, 'Subuh'),
        solatCard(prayerTime.prayerTimes.zohor, 'Zohor'),
        solatCard(prayerTime.prayerTimes.asar, 'Asar'),
        solatCard(prayerTime.prayerTimes.maghrib, 'Maghrib'),
        solatCard(prayerTime.prayerTimes.isyak, 'Isyak'),
        // RaisedButton(
        //   child: Text('DEBUG BUTTON'),
        //   color: Colors.red,
        //   onPressed: () {
        //     print('location is ' + location);
        //     RestartWidget.restartApp(context);
        //   },
        // )
      ],
    );
  }
}

Widget solatCard(String time, String name) {
  return Container(
    width: 300,
    height: 80,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 6.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Colors.teal.withAlpha(30),
        onLongPress: () {
          print('Copied');

          Clipboard.setData(new ClipboardData(text: '$name: $time'))
              .then((value) {
            Fluttertoast.showToast(
                msg: 'Copied to clipboard',
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.grey.shade800,
                textColor: Colors.white);
          });
        },
        child: Center(child: Text(name + ' at $time')),
      ),
    ),
  );
}

String formattedTime(int unixTime) {
  DateTime time = new DateTime.fromMillisecondsSinceEpoch(unixTime * 1000);

  var format = new DateFormat.jm();
  var timeString = format.format(time);
  // print(timeString);

  return timeString;
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
