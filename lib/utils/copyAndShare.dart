import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../CONSTANTS.dart' as constants;
import '../locationUtil/locationDatabase.dart';
import '../providers/settingsProvider.dart';
import 'date_and_time.dart';
import 'prayer_data_handler.dart';

class CopyAndShare {
  static const int _padLength = 8;

  static String getMessage(BuildContext context, {int type = 1}) {
    var _l10n = AppLocalizations.of(context);
    var _date = DateFormat('EEEE, d MMMM yyyy', _l10n!.localeName)
        .format(DateTime.now());
    var _currentLocation =
        GetStorage().read(constants.kStoredLocationJakimCode);
    var _daerah = LocationDatabase.daerah(_currentLocation);
    var _negeri = LocationDatabase.negeri(_currentLocation);
    var _times = PrayDataHandler.today();
    var _use12 =
        Provider.of<SettingProvider>(context, listen: false).use12hour!;
    switch (type) {
      case 1:
        String message = _l10n.shareTitle;
        message += '\n\n';
        message += '🌺 $_date\n';
        message += '📍 $_daerah ($_negeri)\n';
        message += '📆 ${_times.hijri}H\n';
        message += '\n';
        message += '☁ ${_l10n.fajrName}: ${_times.fajr.format(_use12)}\n';
        message += '🌞 ${_l10n.dhuhrName}: ${_times.dhuhr.format(_use12)}\n';
        message += '☀ ${_l10n.asrName}: ${_times.asr.format(_use12)}\n';
        message +=
            '🌙 ${_l10n.maghribName}: ${_times.maghrib.format(_use12)}\n';
        message += '⭐ ${_l10n.ishaName}: ${_times.isha.format(_use12)}\n';
        message += '\n';
        message += _l10n.shareGetApp(constants.kMptFdlGetLink);

        return message;
      case 2:
        String message = _l10n.shareTitle;
        message += '\n\n';
        message += '🌺 *$_date*\n';
        message += '📍 _$_daerah *($_negeri)*_\n';
        message += '📆 ${_times.hijri}H\n';
        message += '\n';
        message +=
            '```☁ ${_l10n.fajrName.padRight(_padLength)}: ${_times.fajr.format(_use12)}```\n';
        message +=
            '```🌞 ${_l10n.dhuhrName.padRight(_padLength)}: ${_times.dhuhr.format(_use12)}```\n';
        message +=
            '```☀ ${_l10n.asrName.padRight(_padLength)}: ${_times.asr.format(_use12)}```\n';
        message +=
            '```🌙 ${_l10n.maghribName.padRight(_padLength)}: ${_times.maghrib.format(_use12)}```\n';
        message +=
            '```⭐ ${_l10n.ishaName.padRight(_padLength)}: ${_times.isha.format(_use12)}```\n';
        message += '\n';
        message += _l10n.shareGetApp(constants.kMptFdlGetLink);

        return message;
      default:
        return '';
    }
  }
}
