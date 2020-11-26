import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/main.dart';
import 'package:provider/provider.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';
import 'package:waktusolatmalaysia/blocs/mpti906_prayer_bloc.dart';
import 'package:waktusolatmalaysia/models/mpti906PrayerData.dart';
import 'package:waktusolatmalaysia/utils/DateAndTime.dart';
import 'package:waktusolatmalaysia/utils/RawPrayDataHandler.dart';
import 'package:waktusolatmalaysia/utils/cachedPrayerData.dart';
import 'package:waktusolatmalaysia/utils/location/locationDatabase.dart';
import 'package:waktusolatmalaysia/utils/notifications_helper.dart';
import 'package:waktusolatmalaysia/utils/sizeconfig.dart';
import 'package:waktusolatmalaysia/views/Settings%20part/settingsProvider.dart';
import '../networking/Response.dart';
import 'package:timezone/timezone.dart' as tz;

LocationDatabase locationDatabase = LocationDatabase();
String location;
Mpti906PrayerBloc prayerBloc;

class GetPrayerTime extends StatefulWidget {
  static void updateUI(int index) {
    var mptLocation = locationDatabase.getMptLocationCode(index);
    prayerBloc.fetchPrayerTime(mptLocation);
  }

  @override
  _GetPrayerTimeState createState() => _GetPrayerTimeState();
}

class _GetPrayerTimeState extends State<GetPrayerTime> {
  @override
  void initState() {
    super.initState();
    location = locationDatabase
        .getMptLocationCode(GetStorage().read(kStoredGlobalIndex));
    prayerBloc = Mpti906PrayerBloc(location);
    print('$location');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response<Mpti906PrayerModel>>(
      stream: prayerBloc.prayDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('snapshot.hasData');
          switch (snapshot.data.status) {
            case Status.LOADING:
              return Loading(loadingMessage: snapshot.data.message);
              break;
            case Status.COMPLETED:
              return PrayTimeList(prayerTime: snapshot.data.data);
              break;
            case Status.ERROR:
              location = locationDatabase
                  .getMptLocationCode(GetStorage().read(kStoredGlobalIndex));
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
  final Mpti906PrayerModel prayerTime;

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
    var prayerTimeData = widget.prayerTime.data;
    handler = PrayDataHandler(prayerTimeData.times);

    return Container(child: Consumer<SettingProvider>(
      builder: (context, setting, child) {
        use12hour = setting.use12hour;
        showOtherPrayerTime = setting.showOtherPrayerTime;
        var todayPrayData = handler.getTodayPrayData();

        String imsakTime = DateAndTime.toTimeReadable(
            todayPrayData[0] - (10 * 60), use12hour); //minus 10 min from subuh
        String subuhTime =
            DateAndTime.toTimeReadable(todayPrayData[0], use12hour);
        String syurukTime =
            DateAndTime.toTimeReadable(todayPrayData[1], use12hour);
        String dhuhaTime = DateAndTime.toTimeReadable(
            todayPrayData[1] + (28 * 60), use12hour); //add 28 min from syuruk
        String zohorTime =
            DateAndTime.toTimeReadable(todayPrayData[2], use12hour);
        String asarTime =
            DateAndTime.toTimeReadable(todayPrayData[3], use12hour);
        String maghribTime =
            DateAndTime.toTimeReadable(todayPrayData[4], use12hour);
        String isyaTime =
            DateAndTime.toTimeReadable(todayPrayData[5], use12hour);

        CachedPrayerTimeData.subuhTime = subuhTime;
        CachedPrayerTimeData.zohorTime = zohorTime;
        CachedPrayerTimeData.asarTime = asarTime;
        CachedPrayerTimeData.maghribTime = maghribTime;
        CachedPrayerTimeData.isyaTime = isyaTime;

        schedulePrayNotification(handler.getPrayDataCurrentDateOnwards());

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
            solatCard(subuhTime, 'Fajr', true),
            showOtherPrayerTime
                ? solatCard(syurukTime, 'Syuruk', false)
                : Container(
                    height: 0,
                  ),
            showOtherPrayerTime
                ? solatCard(dhuhaTime, 'Dhuha', false)
                : Container(
                    height: 0,
                  ),
            solatCard(zohorTime, 'Zuhr', true),
            solatCard(asarTime, 'Asr', true),
            solatCard(maghribTime, 'Maghrib', true),
            solatCard(isyaTime, 'Isya\'', true),
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

void schedulePrayNotification(List<dynamic> times) async {
  await notifsPlugin.cancelAll();

  String currentLocation =
      locationDatabase.getDaerah(GetStorage().read(kStoredGlobalIndex));
  print(currentLocation);

  var currentTime = DateTime.now().millisecondsSinceEpoch;

  for (int i = 0; i < times.length; i++) {
    for (int j = 0; j < 6; j++) {
      var subuhTimeEpoch = times[i][0];
      var syurukTimeEpoch = times[i][1];
      var zuhrTimeEpoch = times[i][2];
      var asarTimeEpoch = times[i][3];
      var maghribTimeEpoch = times[i][4];
      var isyakTimeEpoch = times[i][5];

      if (!(subuhTimeEpoch < currentTime)) {
        scheduleNotification(
          notifsPlugin: notifsPlugin,
          id: subuhTimeEpoch,
          title: 'Fajr Time',
          scheduledTime: tz.TZDateTime.from(
              DateTime.fromMillisecondsSinceEpoch(subuhTimeEpoch), tz.local),
          body: currentLocation,
        );
      }
      if (!(syurukTimeEpoch < currentTime)) {
        scheduleNotification(
            notifsPlugin: notifsPlugin,
            id: syurukTimeEpoch,
            title: 'Syuruk Time',
            body: currentLocation,
            scheduledTime: tz.TZDateTime.from(
                DateTime.fromMillisecondsSinceEpoch(syurukTimeEpoch),
                tz.local));
      }
      if (!(zuhrTimeEpoch < currentTime)) {
        scheduleNotification(
            notifsPlugin: notifsPlugin,
            id: zuhrTimeEpoch,
            title: 'Zuhr Time',
            body: currentLocation,
            scheduledTime: tz.TZDateTime.from(
                DateTime.fromMillisecondsSinceEpoch(zuhrTimeEpoch), tz.local));
      }
      if (!(asarTimeEpoch < currentTime)) {
        scheduleNotification(
            notifsPlugin: notifsPlugin,
            id: asarTimeEpoch,
            title: 'Asr Time',
            body: currentLocation,
            scheduledTime: tz.TZDateTime.from(
                DateTime.fromMillisecondsSinceEpoch(asarTimeEpoch), tz.local));
      }
      if (!(maghribTimeEpoch < currentTime)) {
        scheduleNotification(
            notifsPlugin: notifsPlugin,
            id: maghribTimeEpoch,
            title: 'Maghrib Time',
            body: currentLocation,
            scheduledTime: tz.TZDateTime.from(
                DateTime.fromMillisecondsSinceEpoch(maghribTimeEpoch),
                tz.local));
      }
      if (!(isyakTimeEpoch < currentTime)) {
        scheduleNotification(
            notifsPlugin: notifsPlugin,
            id: isyakTimeEpoch,
            title: 'Isya\' Time',
            body: currentLocation,
            scheduledTime: tz.TZDateTime.from(
                DateTime.fromMillisecondsSinceEpoch(isyakTimeEpoch), tz.local));
      }
      print('Subuh @ $subuhTimeEpoch');
      print('Syuruk @ $syurukTimeEpoch');
      print('Zohor @ $zuhrTimeEpoch');
      print('Asar @ $asarTimeEpoch');
      print('Maghrib @ $maghribTimeEpoch');
      print('Isyak @ $isyakTimeEpoch');
    }
  }
  // print('times is $times');
  // scheduleNotification(
  //           notifsPlugin: notifsPlugin,
  //           id: '1604714840',
  //           body: 'Scehdule azan',
  //           title: 'Minutes noti after 5',
  //           scheduledTime: tz.TZDateTime.from(
  //               newTime.add(Duration(seconds: 5)), tz.local));
}
