import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:waktusolatmalaysia/blocs/jakim_prayer_bloc.dart';
import 'package:waktusolatmalaysia/models/jakim_prayer_model.dart';
import 'package:waktusolatmalaysia/utils/isolate_handler_notification.dart';
import 'package:waktusolatmalaysia/utils/prayer_time_model.dart';
import '../CONSTANTS.dart';
import '../utils/DateAndTime.dart';
import '../utils/RawPrayDataHandler.dart';
import '../utils/cachedPrayerData.dart';
import '../utils/location/locationDatabase.dart';
import '../utils/prayerName.dart';
import '../utils/prevent_update_notifs.dart';
import '../utils/sizeconfig.dart';
import 'Settings%20part/settingsProvider.dart';
import '../networking/Response.dart';

LocationDatabase locationDatabase = LocationDatabase();
String location;
JakimPrayerBloc prayerBloc;

class GetPrayerTime extends StatefulWidget {
  static void updateUI(int index) {
    var location = locationDatabase.getJakimCode(index);
    prayerBloc.fetchPrayerTime(location);
  }

  @override
  _GetPrayerTimeState createState() => _GetPrayerTimeState();
}

class _GetPrayerTimeState extends State<GetPrayerTime> {
  @override
  void initState() {
    super.initState();
    location =
        locationDatabase.getJakimCode(GetStorage().read(kStoredGlobalIndex));
    prayerBloc = JakimPrayerBloc(location);
    print('location is $location');
    PreventUpdatingNotifs.setNow();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response<JakimPrayerModel>>(
      stream: prayerBloc.prayDataStream,
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
              location = locationDatabase
                  .getJakimCode(GetStorage().read(kStoredGlobalIndex));
              return Error(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => prayerBloc.fetchPrayerTime(location),
              );
              break;
          }
        }
        return Container(
          child: Text('Uh it supposed not showing here'),
        );
      },
    );
  }

  @override
  void dispose() {
    prayerBloc.dispose();
    super.dispose();
  }
}

class PrayTimeList extends StatefulWidget {
  final JakimPrayerModel prayerTime;

  PrayTimeList({Key key, this.prayerTime}) : super(key: key);

  @override
  _PrayTimeListState createState() => _PrayTimeListState();
}

class _PrayTimeListState extends State<PrayTimeList> {
  PrayDataHandler handler;
  bool use12hour = GetStorage().read(kStoredTimeIs12);
  bool showOtherPrayerTime;

  @override
  Widget build(BuildContext context) {
    var prayerTimeData = widget.prayerTime;
    // print('prayerTimeData is $prayerTimeData');
    handler = PrayDataHandler(prayerTimeData.prayerTime);
    if (!kIsWeb && GetStorage().read(kStoredShouldUpdateNotif)) {
      schedulePrayNotification(
          handler.getPrayDataCurrentDateOnwards()); //schedule notification
    }

    return Container(child: Consumer<SettingProvider>(
      builder: (context, setting, child) {
        use12hour = setting.use12hour;
        showOtherPrayerTime = setting.showOtherPrayerTime;
        CustomPrayerTimeModel todayData = handler.getTodayPrayData();

        var imsakTime = DateAndTime.toTimeReadable(todayData.imsak, use12hour);
        var subuhTime = DateAndTime.toTimeReadable(todayData.subuh, use12hour);
        var syurukTime =
            DateAndTime.toTimeReadable(todayData.syuruk, use12hour);
        var dhuhaTime = DateAndTime.toTimeReadable(todayData.dhuha, use12hour);
        var zohorTime = DateAndTime.toTimeReadable(todayData.zohor, use12hour);
        var asarTime = DateAndTime.toTimeReadable(todayData.asar, use12hour);
        var maghribTime =
            DateAndTime.toTimeReadable(todayData.maghrib, use12hour);
        var isyaTime = DateAndTime.toTimeReadable(todayData.isyak, use12hour);

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
            showOtherPrayerTime
                ? solatCard(imsakTime, 'Imsak', false)
                : Container(
                    height: 0,
                  ),
            solatCard(subuhTime, PrayerName.prayerName[0], true),
            showOtherPrayerTime
                ? solatCard(syurukTime, PrayerName.prayerName[1], false)
                : Container(
                    height: 0,
                  ),
            showOtherPrayerTime
                ? solatCard(dhuhaTime, 'Dhuha', false)
                : Container(
                    height: 0,
                  ),
            solatCard(zohorTime, PrayerName.prayerName[2], true),
            solatCard(asarTime, PrayerName.prayerName[3], true),
            solatCard(maghribTime, PrayerName.prayerName[4], true),
            solatCard(isyaTime, PrayerName.prayerName[5], true),
          ],
        );
      },
    ));
  }
}

Widget solatCard(String time, String name, bool useFullHeight) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight / 320),
    width: 300,
    height: useFullHeight ? 80 : 55,
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
    print('errorMessage is $errorMessage');
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
