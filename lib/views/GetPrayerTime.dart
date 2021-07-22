import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'Settings%20part/settingsProvider.dart';
import '../CONSTANTS.dart';
import '../locationUtil/locationDatabase.dart';
import '../locationUtil/location_provider.dart';
import '../models/mpti906PrayerData.dart';
import '../notificationUtil/isolate_handler_notification.dart';
import '../notificationUtil/prevent_update_notifs.dart';
import '../utils/DateAndTime.dart';
import '../utils/RawPrayDataHandler.dart';
import '../utils/temp_prayer_data.dart';
import '../utils/mpt_fetch_api.dart';
import '../utils/sizeconfig.dart';

String location;

class GetPrayerTime extends StatefulWidget {
  const GetPrayerTime({Key key}) : super(key: key);
  @override
  _GetPrayerTimeState createState() => _GetPrayerTimeState();
}

class _GetPrayerTimeState extends State<GetPrayerTime> {
  @override
  void initState() {
    super.initState();
    PreventUpdatingNotifs.setNow();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, value, child) {
        return FutureBuilder<Mpti906PrayerModel>(
          future: MptApiFetch.fetchMpt(
              LocationDatabase.getMptLocationCode(value.currentLocationIndex)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else if (snapshot.hasData) {
              return PrayTimeList(prayerTime: snapshot.data);
            } else {
              return Error(
                errorMessage: snapshot.error.toString(),
                onRetryPressed: () => setState(() {}),
              );
            }
          },
        );
      },
    );
  }
}

class PrayTimeList extends StatefulWidget {
  const PrayTimeList({Key key, this.prayerTime}) : super(key: key);
  final Mpti906PrayerModel prayerTime;

  @override
  _PrayTimeListState createState() => _PrayTimeListState();
}

class _PrayTimeListState extends State<PrayTimeList> {
  bool use12hour = GetStorage().read(kStoredTimeIs12);
  bool showOtherPrayerTime;

  @override
  Widget build(BuildContext context) {
    var prayerTimeData = widget.prayerTime.data;

    if (GetStorage().read(kStoredShouldUpdateNotif)) {
      //schedule notification if needed
      schedulePrayNotification(
          PrayDataHandler.removePastDate(prayerTimeData.times));
    }

    return Consumer<SettingProvider>(
      builder: (context, setting, child) {
        use12hour = setting.use12hour;
        showOtherPrayerTime = setting.showOtherPrayerTime;
        var _today = PrayDataHandler.todayPrayData(prayerTimeData.times);

        String imsakTime = DateAndTime.toTimeReadable(
            _today[0] - (10 * 60), use12hour); //minus 10 min from subuh
        String subuhTime = DateAndTime.toTimeReadable(_today[0], use12hour);
        String syurukTime = DateAndTime.toTimeReadable(_today[1], use12hour);
        String dhuhaTime = DateAndTime.toTimeReadable(
            _today[1] + (28 * 60), use12hour); //add 28 min from syuruk
        String zohorTime = DateAndTime.toTimeReadable(_today[2], use12hour);
        String asarTime = DateAndTime.toTimeReadable(_today[3], use12hour);
        String maghribTime = DateAndTime.toTimeReadable(_today[4], use12hour);
        String isyaTime = DateAndTime.toTimeReadable(_today[5], use12hour);

        TempPrayerTimeData.subuhTime = subuhTime;
        TempPrayerTimeData.zohorTime = zohorTime;
        TempPrayerTimeData.asarTime = asarTime;
        TempPrayerTimeData.maghribTime = maghribTime;
        TempPrayerTimeData.isyaTime = isyaTime;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            showOtherPrayerTime
                ? solatCard(imsakTime, 'Imsak', false)
                : Container(),
            solatCard(subuhTime, 'Subuh', true),
            showOtherPrayerTime
                ? solatCard(syurukTime, 'Syuruk', false)
                : Container(),
            showOtherPrayerTime
                ? solatCard(dhuhaTime, 'Dhuha', false)
                : Container(),
            solatCard(zohorTime, 'Zohor', true),
            solatCard(asarTime, 'Asar', true),
            solatCard(maghribTime, 'Maghrib', true),
            solatCard(isyaTime, 'Isyak', true),
          ],
        );
      },
    );
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
        onLongPress: () =>
            Clipboard.setData(ClipboardData(text: '$name: $time'))
                .then((value) {
          Fluttertoast.showToast(
              msg: 'Copied to clipboard',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.grey.shade700,
              textColor: Colors.white);
        }),
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

class Error extends StatelessWidget {
  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  final String errorMessage;
  final Function onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          child: const Text('Retry', style: TextStyle(color: Colors.black)),
          onPressed: onRetryPressed,
        )
      ],
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Fetching prayer time. Please wait.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 24),
        SpinKitChasingDots(
          size: 35,
          color: Colors.teal,
        ),
      ],
    );
  }
}
