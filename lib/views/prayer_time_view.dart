import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../models/mpt_server_solat.dart';
import '../notificationUtil/notification_scheduler.dart';
import '../notificationUtil/prevent_update_notifs.dart';
import '../providers/setting_provider.dart';
import '../utils/date_and_time.dart';
import '../utils/prayer_data_handler.dart';

String? location;

class PrayTimeList extends StatefulWidget {
  const PrayTimeList({super.key, this.prayerTime});
  final MptServerSolat? prayerTime;

  @override
  State<PrayTimeList> createState() => _PrayTimeListState();
}

class _PrayTimeListState extends State<PrayTimeList> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();

    _listener = AppLifecycleListener(onStateChange: _onStateChanged);
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _onStateChanged(AppLifecycleState state) {
    // When app resume from back to view, refresh UI so that
    // the highlighted time can be updated
    if (state == AppLifecycleState.resumed) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (PreventUpdatingNotifs.shouldUpdate()) {
      MyNotifScheduler.schedulePrayNotification(
          AppLocalizations.of(context)!, PrayDataHandler.notificationTimes());
    }

    return Consumer<SettingProvider>(
      builder: (_, setting, __) {
        final bool showOtherPrayerTime = setting.showOtherPrayerTime;
        final today = PrayDataHandler.today();

        final now = DateTime.now();

        bool nowSubuh = false,
            nowZohor = false,
            nowAsar = false,
            nowMaghrib = false,
            nowIsha = false;

        if (now.isAfter(today.fajr) && now.isBefore(today.syuruk)) {
          nowSubuh = true;
        } else if (now.isAfter(today.dhuhr) && now.isBefore(today.asr)) {
          nowZohor = true;
        } else if (now.isAfter(today.asr) && now.isBefore(today.maghrib)) {
          nowAsar = true;
        } else if (now.isAfter(today.maghrib) && now.isBefore(today.isha)) {
          nowMaghrib = true;
        } else if (now.isAfter(today.isha) &&
            now.isBefore(today.fajr.add(const Duration(days: 1)))) {
          nowIsha = true;
        }

        return AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder: (widget) {
                return SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                );
              },
              children: [
                if (showOtherPrayerTime)
                  SolatCard(
                      time: today.imsak,
                      name: AppLocalizations.of(context)!.imsakName,
                      isOther: false),
                SolatCard(
                  time: today.fajr,
                  name: AppLocalizations.of(context)!.fajrName,
                  isOther: true,
                  isCurrentPrayerTime: nowSubuh,
                ),
                if (showOtherPrayerTime)
                  SolatCard(
                      time: today.syuruk,
                      name: AppLocalizations.of(context)!.sunriseName,
                      isOther: false),
                if (showOtherPrayerTime)
                  SolatCard(
                      time: today.dhuha,
                      name: AppLocalizations.of(context)!.dhuhaName,
                      isOther: false),
                SolatCard(
                  time: today.dhuhr,
                  name: AppLocalizations.of(context)!.dhuhrName,
                  isOther: true,
                  isCurrentPrayerTime: nowZohor,
                ),
                SolatCard(
                  time: today.asr,
                  name: AppLocalizations.of(context)!.asrName,
                  isOther: true,
                  isCurrentPrayerTime: nowAsar,
                ),
                SolatCard(
                  time: today.maghrib,
                  name: AppLocalizations.of(context)!.maghribName,
                  isOther: true,
                  isCurrentPrayerTime: nowMaghrib,
                ),
                SolatCard(
                  time: today.isha,
                  name: AppLocalizations.of(context)!.ishaName,
                  isOther: true,
                  isCurrentPrayerTime: nowIsha,
                ),
                const SizedBox(height: 10), // give some bottom space
              ],
            ),
          ),
        );
      },
    );
  }
}

class SolatCard extends StatelessWidget {
  const SolatCard(
      {super.key,
      required this.isOther,
      required this.name,
      required this.time,
      this.isCurrentPrayerTime = false});

  /// Imsak, Syuruk, Dhuha set to true
  final bool isOther;
  final String name;
  final DateTime time;
  final bool isCurrentPrayerTime;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
      builder: (_, value, __) => Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 320),
        height: isOther ? 80 : 55,
        child: Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Theme.of(context).colorScheme.surfaceVariant,
            onLongPress: () => Clipboard.setData(ClipboardData(
                    text: '$name: ${time.format(value.use12hour)}'))
                .then((value) {
              Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!.getPtCopied,
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.grey.shade700,
                textColor: Colors.white,
              );
            }),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!
                    .getPtTimeAt(name, time.format(value.use12hour)),
                style: TextStyle(
                    fontSize: value.prayerFontSize,
                    fontWeight: isCurrentPrayerTime
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
