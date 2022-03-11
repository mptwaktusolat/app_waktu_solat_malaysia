import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../CONSTANTS.dart';
import '../models/jakim_esolat_model.dart';
import '../notificationUtil/notification_scheduler.dart';
import '../notificationUtil/prevent_update_notifs.dart';
import '../providers/settingsProvider.dart';
import '../utils/prayer_data_handler.dart';

String? location;

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
    if (PreventUpdatingNotifs.shouldUpdate()) {
      MyNotifScheduler.schedulePrayNotification(
          context, PrayDataHandler.notificationTimes());
    }

    return Consumer<SettingProvider>(
      builder: (_, setting, __) {
        use12hour = setting.use12hour;
        showOtherPrayerTime = setting.showOtherPrayerTime;
        var _today = PrayDataHandler.todayReadable(setting.use12hour!);

        String imsakTime = _today[0];
        String subuhTime = _today[1];
        String syurukTime = _today[2];
        String dhuhaTime = _today[3];
        String zohorTime = _today[4];
        String asarTime = _today[5];
        String maghribTime = _today[6];
        String isyaTime = _today[7];

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            if (showOtherPrayerTime!)
              SolatCard(
                  time: imsakTime,
                  name: AppLocalizations.of(context)!.imsakName,
                  isOther: false),
            SolatCard(
                time: subuhTime,
                name: AppLocalizations.of(context)!.fajrName,
                isOther: true),
            if (showOtherPrayerTime!)
              SolatCard(
                  time: syurukTime,
                  name: AppLocalizations.of(context)!.sunriseName,
                  isOther: false),
            if (showOtherPrayerTime!)
              SolatCard(
                  time: dhuhaTime,
                  name: AppLocalizations.of(context)!.dhuhaName,
                  isOther: false),
            SolatCard(
                time: zohorTime,
                name: AppLocalizations.of(context)!.dhuhrName,
                isOther: true),
            SolatCard(
                time: asarTime,
                name: AppLocalizations.of(context)!.asrName,
                isOther: true),
            SolatCard(
                time: maghribTime,
                name: AppLocalizations.of(context)!.maghribName,
                isOther: true),
            SolatCard(
                time: isyaTime,
                name: AppLocalizations.of(context)!.ishaName,
                isOther: true),
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
  final String name, time;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height / 320),
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
              msg: AppLocalizations.of(context)!.getPtCopied,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.grey.shade700,
              textColor: Colors.white,
            );
          }),
          child: Center(child: Consumer<SettingProvider>(
            builder: (_, setting, __) {
              return Text(
                AppLocalizations.of(context)!.getPtTimeAt(name, time),
                style: TextStyle(fontSize: setting.prayerFontSize),
              );
            },
          )),
        ),
      ),
    );
  }
}
