import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/blocs/waktusolatapp_bloc.dart';
import 'package:waktusolatmalaysia/models/waktusolatappapi.dart';
import 'package:waktusolatmalaysia/utils/DateAndTime.dart';
import 'package:waktusolatmalaysia/utils/cachedPrayerData.dart';
import 'package:waktusolatmalaysia/utils/location/locationDatabase.dart';
import 'package:waktusolatmalaysia/utils/sizeconfig.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart' as Constants;
import '../networking/Response.dart';

LocationDatabase locationDatabase = LocationDatabase();
String location;
WaktusolatappBloc _timeBloc;

class GetPrayerTime extends StatefulWidget {
  static void updateUI(String location) {
    _timeBloc.fetchPrayerTime(location, null);
  }

  @override
  _GetPrayerTimeState createState() => _GetPrayerTimeState();
}

class _GetPrayerTimeState extends State<GetPrayerTime> {
  // String timeFormat = "&format=12-hour";

  @override
  void initState() {
    super.initState();
    location =
        locationDatabase.getJakimCode(GetStorage().read(kStoredGlobalIndex));
    _timeBloc = WaktusolatappBloc(location, null);
    print('$location');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response<WaktuSolatApp>>(
      stream: _timeBloc.prayDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('snapshot.hasData');
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
              location = locationDatabase
                  .getJakimCode(GetStorage().read(kStoredGlobalIndex));
              return Error(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => _timeBloc.fetchPrayerTime(location, null),
              );
              break;
          }
        }
        return Container(
          child: Text('empty here'),
        );
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
  // final AzanPro prayerTime;
  final WaktuSolatApp prayerTime;

  PrayTimeList({Key key, this.prayerTime}) : super(key: key);

  final int day =
      int.parse(DateFormat('d').format(DateTime.now())); //example: 21

  //since array start at 0, the date should be minus 1

  @override
  Widget build(BuildContext context) {
    int arrayDay = day - 1;
    String subuhTime =
        DateAndTime.toAmPmReadable(prayerTime.data.prayTimes[arrayDay].subuh);
    String zohorTime =
        DateAndTime.toAmPmReadable(prayerTime.data.prayTimes[arrayDay].zohor);
    String asarTime =
        DateAndTime.toAmPmReadable(prayerTime.data.prayTimes[arrayDay].asar);
    String maghribTime =
        DateAndTime.toAmPmReadable(prayerTime.data.prayTimes[arrayDay].maghrib);
    String isyaTime =
        DateAndTime.toAmPmReadable(prayerTime.data.prayTimes[arrayDay].isyak);

    CachedPrayerTimeData.subuhTime = subuhTime;
    CachedPrayerTimeData.zohorTime = zohorTime;
    CachedPrayerTimeData.asarTime = asarTime;
    CachedPrayerTimeData.maghribTime = maghribTime;
    CachedPrayerTimeData.isyaTime = isyaTime;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // solatCard('$subuhTime', 'Status'),

        solatCard(subuhTime, 'Fajr'),
        solatCard(zohorTime, 'Zuhr'),
        solatCard(asarTime, 'Asr'),
        solatCard(maghribTime, 'Maghrib'),
        solatCard(isyaTime, 'Isya\''),

        // RaisedButton(
        //   child: Text('DEBUG BUTTON'),
        //   color: Colors.red,
        //   onPressed: () {
        //     print('location is ' + location);
        //   },
        // )
      ],
    );
  }
}

Widget solatCard(String time, String name) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight / 320),
    width: 300,
    height: 80,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 4.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Colors.teal.withAlpha(30),
        onLongPress: () {
          print('Copied');

          Clipboard.setData(new ClipboardData(text: '$name: $time'))
              .then((value) {
            // Vibration.vibrate();
            Fluttertoast.showToast(
                msg: 'Copied to clipboard',
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.grey.shade700,
                textColor: Colors.white);
          });
        },
        child: Center(child: Text(name + ' at $time')),
      ),
    ),
  );
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
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          SpinKitChasingDots(
            size: 35,
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}
