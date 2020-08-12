import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/blocs/azan_times_today_bloc.dart';
import 'package:waktusolatmalaysia/models/azanproapi.dart';

import 'networking/Response.dart';

class GetPrayerTime extends StatefulWidget {
  @override
  _GetPrayerTimeState createState() => _GetPrayerTimeState();
}

class _GetPrayerTimeState extends State<GetPrayerTime> {
  PrayTimeBloc _timeBloc;
  String location = "sgr01";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('en_US', null);
    _timeBloc = PrayTimeBloc(location);
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
              return PrayTimeList(prayerTime: snapshot.data.data);
              break;
            case Status.ERROR:
              return Error(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => _timeBloc.fetchPrayerTime(location),
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

//TODO: Stop using timestamp converter, may introduce error or incompatibility issues

class PrayTimeList extends StatelessWidget {
  final PrayerTime prayerTime;

  const PrayTimeList({Key key, this.prayerTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        solatCard(prayerTime.prayerTimes.subuh, 'Subuh'),
        solatCard(prayerTime.prayerTimes.zohor, 'Zohor'),
        solatCard(prayerTime.prayerTimes.asar, 'Asar'),
        solatCard(prayerTime.prayerTimes.maghrib, 'Maghrib'),
        solatCard(prayerTime.prayerTimes.isyak, 'Isyak'),
      ],
    );
  }
}

Widget solatCard(int time, String name) {
  var formatTime = formattedTime(time);

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
          //TODO: Copy function and toast
        },
        onTap: () {
          print('Pressed');
        },
        child: Center(child: Text(name + ' at ' + formatTime)),
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
