import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../models/jakim_esolat_model.dart';
import '../providers/settingsProvider.dart';
import '../CONSTANTS.dart';
import '../providers/location_provider.dart';
import '../notificationUtil/notification_scheduler.dart';
import '../notificationUtil/prevent_update_notifs.dart';
import '../utils/DateAndTime.dart';
import '../utils/RawPrayDataHandler.dart';
import '../utils/temp_prayer_data.dart';
import '../utils/mpt_fetch_api.dart';
import '../utils/sizeconfig.dart';

String? location;

class GetPrayerTime extends StatefulWidget {
  const GetPrayerTime({Key? key}) : super(key: key);
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
        return FutureBuilder<JakimEsolatModel>(
          future: MptApiFetch.fetchMpt(value.currentLocationCode),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading();
            } else if (snapshot.hasData) {
              return PrayTimeList(prayerTime: snapshot.data);
            } else {
              print(snapshot.error);
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
  const PrayTimeList({Key? key, this.prayerTime}) : super(key: key);
  final JakimEsolatModel? prayerTime;

  @override
  _PrayTimeListState createState() => _PrayTimeListState();
}

class _PrayTimeListState extends State<PrayTimeList> {
  bool? use12hour = GetStorage().read(kStoredTimeIs12);
  bool? showOtherPrayerTime;

  @override
  Widget build(BuildContext context) {
    var prayerTimeData = widget.prayerTime?.prayerTime;

    if (GetStorage().read(kStoredShouldUpdateNotif)) {
      //schedule notification if needed
      MyNotifScheduler.schedulePrayNotification(
          PrayDataHandler.removePastDate(prayerTimeData!));
    }

    return Consumer<SettingProvider>(
      builder: (context, setting, child) {
        use12hour = setting.use12hour;
        showOtherPrayerTime = setting.showOtherPrayerTime;
        var _today = PrayDataHandler.todayPrayData(prayerTimeData!)!;

        String imsakTime = DateAndTime.toTimeReadable(_today[0], use12hour!);
        String subuhTime = DateAndTime.toTimeReadable(_today[1], use12hour!);
        String syurukTime = DateAndTime.toTimeReadable(_today[2], use12hour!);
        String dhuhaTime = DateAndTime.toTimeReadable(_today[3], use12hour!);
        String zohorTime = DateAndTime.toTimeReadable(_today[4], use12hour!);
        String asarTime = DateAndTime.toTimeReadable(_today[5], use12hour!);
        String maghribTime = DateAndTime.toTimeReadable(_today[6], use12hour!);
        String isyaTime = DateAndTime.toTimeReadable(_today[7], use12hour!);

        TempPrayerTimeData.subuhTime = subuhTime;
        TempPrayerTimeData.zohorTime = zohorTime;
        TempPrayerTimeData.asarTime = asarTime;
        TempPrayerTimeData.maghribTime = maghribTime;
        TempPrayerTimeData.isyaTime = isyaTime;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if (showOtherPrayerTime!)
              SolatCard(time: imsakTime, name: 'Imsak', isOther: false),
            SolatCard(time: subuhTime, name: 'Subuh', isOther: true),
            if (showOtherPrayerTime!)
              SolatCard(time: syurukTime, name: 'Syuruk', isOther: false),
            if (showOtherPrayerTime!)
              SolatCard(time: dhuhaTime, name: 'Dhuha', isOther: false),
            SolatCard(time: zohorTime, name: 'Zohor', isOther: true),
            SolatCard(time: asarTime, name: 'Asar', isOther: true),
            SolatCard(time: maghribTime, name: 'Maghrib', isOther: true),
            SolatCard(time: isyaTime, name: 'Isyak', isOther: true),
          ],
        );
      },
    );
  }
}

class SolatCard extends StatelessWidget {
  const SolatCard(
      {Key? key, required this.isOther, required this.name, required this.time})
      : super(key: key);

  /// Imsak, Syuruk, Dhuha set to true
  final bool isOther;
  final String name;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      margin: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight / 320),
      height: isOther ? 80 : 55,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        shadowColor: Colors.black54,
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
              textColor: Colors.white,
            );
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
}

class Error extends StatelessWidget {
  const Error({Key? key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  final String? errorMessage;
  final Function? onRetryPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 15),
        Text(
          errorMessage!.isEmpty
              ? 'Unexpected error. Please retry'
              : errorMessage!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          child: const Text('Retry', style: TextStyle(color: Colors.black)),
          onPressed: onRetryPressed as void Function()?,
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 15),
        Text(
          'Fetching prayer time. Please wait.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 200),
          child: SpinKitChasingDots(
            size: 35,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }
}
