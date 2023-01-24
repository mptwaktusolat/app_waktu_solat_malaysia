import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../CONSTANTS.dart' as constants;
import '../location_utils/location_database.dart';
import '../providers/setting_provider.dart';
import 'date_and_time.dart';
import 'prayer_data_handler.dart';

enum ShareTarget { universal, whatsapp }

class CopyAndShare {
  static const int _padLength = 8;

  static String getMessage(BuildContext context,
      {ShareTarget shareTarget = ShareTarget.universal}) {
    var l10n = AppLocalizations.of(context);
    var date = DateFormat('EEEE, d MMMM yyyy', l10n!.localeName)
        .format(DateTime.now());
    var currentLocation = GetStorage().read(constants.kStoredLocationJakimCode);
    var daerah = LocationDatabase.daerah(currentLocation);
    var negeri = LocationDatabase.negeri(currentLocation);
    var times = PrayDataHandler.today();
    var use12 = Provider.of<SettingProvider>(context, listen: false).use12hour;
    switch (shareTarget) {
      case ShareTarget.universal:
        String message = l10n.shareTitle;
        message += '\n\n';
        message += '🌺 $date\n';
        message += '📍 $daerah ($negeri)\n';
        message += '📆 ${times.hijri}H\n';
        message += '\n';
        message += '☁ ${l10n.fajrName}: ${times.fajr.format(use12)}\n';
        message += '🌞 ${l10n.dhuhrName}: ${times.dhuhr.format(use12)}\n';
        message += '☀ ${l10n.asrName}: ${times.asr.format(use12)}\n';
        message += '🌙 ${l10n.maghribName}: ${times.maghrib.format(use12)}\n';
        message += '⭐ ${l10n.ishaName}: ${times.isha.format(use12)}\n';
        message += '\n';
        message += l10n.shareGetApp(constants.kMptFdlGetLink);

        return message;
      case ShareTarget.whatsapp:
        String message = l10n.shareTitle;
        message += '\n\n';
        message += '🌺 *$date*\n';
        message += '📍 _$daerah *($negeri)*_\n';
        message += '📆 ${times.hijri}H\n';
        message += '\n';
        message +=
            '```☁ ${l10n.fajrName.padRight(_padLength)}: ${times.fajr.format(use12)}```\n';
        message +=
            '```🌞 ${l10n.dhuhrName.padRight(_padLength)}: ${times.dhuhr.format(use12)}```\n';
        message +=
            '```☀ ${l10n.asrName.padRight(_padLength)}: ${times.asr.format(use12)}```\n';
        message +=
            '```🌙 ${l10n.maghribName.padRight(_padLength)}: ${times.maghrib.format(use12)}```\n';
        message +=
            '```⭐ ${l10n.ishaName.padRight(_padLength)}: ${times.isha.format(use12)}```\n';
        message += '\n';
        message += l10n.shareGetApp(constants.kMptFdlGetLink);

        return message;
    }
  }
}
