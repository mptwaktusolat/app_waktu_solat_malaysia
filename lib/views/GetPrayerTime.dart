import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../CONSTANTS.dart';
import '../blocs/mpti906_prayer_bloc.dart';
import '../models/mpti906PrayerData.dart';
import '../networking/Response.dart';
import '../utils/DateAndTime.dart';
import '../utils/RawPrayDataHandler.dart';
import '../utils/cachedPrayerData.dart';
import '../utils/location/locationDatabase.dart';
import 'Settings%20part/settingsProvider.dart';

LocationDatabase locationDatabase = LocationDatabase();
String location;
Mpti906PrayerBloc prayerBloc;

class GetPrayerTime extends StatefulWidget {
  static void updateUI(int index) {
    var location = locationDatabase.getMptLocationCode(index);
    prayerBloc.fetchPrayerTime(location);
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
    print('location is $location');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Response<Mpti906PrayerModel>>(
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

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 700) {
              return buildSmallLayout(imsakTime, subuhTime, syurukTime,
                  dhuhaTime, zohorTime, asarTime, maghribTime, isyaTime);
            } else {
              return buildWideLayout(imsakTime, subuhTime, syurukTime,
                  dhuhaTime, zohorTime, asarTime, maghribTime, isyaTime);
            }
          },
        );
      },
    ));
  }

  Wrap buildWideLayout(
      String imsakTime,
      String subuhTime,
      String syurukTime,
      String dhuhaTime,
      String zohorTime,
      String asarTime,
      String maghribTime,
      String isyaTime) {
    return Wrap(
      children: [
        showOtherPrayerTime
            ? rowSolatCard(imsakTime, 'Imsak', false)
            : SizedBox.shrink(),
        rowSolatCard(subuhTime, 'Subuh', true),
        showOtherPrayerTime
            ? rowSolatCard(syurukTime, 'Syuruk', false)
            : SizedBox.shrink(),
        showOtherPrayerTime
            ? rowSolatCard(dhuhaTime, 'Dhuha', false)
            : SizedBox.shrink(),
        rowSolatCard(zohorTime, 'Zohor', true),
        rowSolatCard(asarTime, 'Asar', true),
        rowSolatCard(maghribTime, 'Maghrib', true),
        rowSolatCard(isyaTime, 'Isyak', true),
      ],
    );
  }

  Column buildSmallLayout(
      String imsakTime,
      String subuhTime,
      String syurukTime,
      String dhuhaTime,
      String zohorTime,
      String asarTime,
      String maghribTime,
      String isyaTime) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        showOtherPrayerTime
            ? columnSolatCard(imsakTime, 'Imsak', false)
            : Container(),
        columnSolatCard(subuhTime, 'Subuh', true),
        showOtherPrayerTime
            ? columnSolatCard(syurukTime, 'Syuruk', false)
            : Container(),
        showOtherPrayerTime
            ? columnSolatCard(dhuhaTime, 'Dhuha', false)
            : Container(),
        columnSolatCard(zohorTime, 'Zohor', true),
        columnSolatCard(asarTime, 'Asar', true),
        columnSolatCard(maghribTime, 'Maghrib', true),
        columnSolatCard(isyaTime, 'Isyak', true),
      ],
    );
  }
}

Widget columnSolatCard(String time, String name, bool useFullHeight) {
  return Container(
    // margin: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight / 320),
    height: useFullHeight ? 80 : 55,
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Colors.teal.withAlpha(30),
        onTap: () => copySolatTime(name, time),
        child: Center(child: Consumer<SettingProvider>(
          builder: (context, setting, child) {
            return Text(
              name + ' at $time',
              style: TextStyle(fontSize: setting.prayerFontSize),
            );
          },
        )),
      ),
    ),
  );
}

Widget rowSolatCard(String time, String name, bool useFullHeight) {
  return Container(
    // margin: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight / 320),
    height: 120,
    width: 300,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 4.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Colors.teal.withAlpha(30),
        onTap: () => copySolatTime(name, time),
        child: Center(child: Consumer<SettingProvider>(
          builder: (context, setting, child) {
            return Text(
              '$name at\n$time',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: setting.prayerFontSize),
            );
          },
        )),
      ),
    ),
  );
}

void copySolatTime(String name, String time) {
  print('Copied');
  Clipboard.setData(new ClipboardData(text: '$name: $time')).then((value) {
    Fluttertoast.showToast(
        msg: 'Copied to clipboard',
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey.shade700,
        textColor: Colors.white);
  });
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).buttonColor,
            ),
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
