import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../env.dart';
import '../../../location_utils/location_database.dart';
import '../../../models/mpt_server_solat.dart';
import '../../../shared/extensions/date_time_extensions.dart';
import '../../../utils/prayer_data_handler.dart';

enum ShareTarget { universal, copy, whatsapp, image }

/// Builder for share text.
class ShareTextBuilder {
  /// Instance of [AppLocalizations].
  final AppLocalizations _appLocalizations;

  /// Whether to use 12-hour format.
  final bool _use12hourFormat;

  /// Formatted date string.
  final String _date;

  /// Daerah name.
  final String _daerah;

  /// Negeri name.
  final String _negeri;

  /// Prayer times.
  final Prayers _times;

  final int _padLength = 8;

  ShareTextBuilder(this._appLocalizations, {bool use12hourFormat = false})
      : _use12hourFormat = use12hourFormat,
        _date = DateFormat('EEEE, d MMMM yyyy', _appLocalizations.localeName)
            .format(DateTime.now()),
        _daerah = LocationDatabase.daerah(
            GetStorage().read(kStoredLocationJakimCode)),
        _negeri = LocationDatabase.negeri(
            GetStorage().read(kStoredLocationJakimCode)),
        _times = PrayDataHandler.today();

  /// Format the text for sharing. This is for plain text.
  String formatPlainText() {
    final StringBuffer message = StringBuffer();
    message.write(_appLocalizations.shareTitle);
    message.writeln();
    message.writeln();
    message.writeln('🌺 $_date');
    message.writeln('📍 $_daerah ($_negeri)');
    message.writeln('📆 ${_times.hijri}H');
    message.writeln();
    message.writeln(
        '☁ ${_appLocalizations.fajrName}: ${_times.fajr.readable(_use12hourFormat)}');
    message.writeln(
        '🌞 ${_appLocalizations.dhuhrName}: ${_times.dhuhr.readable(_use12hourFormat)}');
    message.writeln(
        '☀ ${_appLocalizations.asrName}: ${_times.asr.readable(_use12hourFormat)}');
    message.writeln(
        '🌙 ${_appLocalizations.maghribName}: ${_times.maghrib.readable(_use12hourFormat)}');
    message.writeln(
        '⭐ ${_appLocalizations.ishaName}: ${_times.isha.readable(_use12hourFormat)}');
    message.writeln();
    message.write(_appLocalizations.shareGetApp(envAppWebsite));
    return message.toString();
  }

  /// Format the text for sharing. This is for WhatsApp.
  String formatWhatsApp() {
    final StringBuffer message = StringBuffer();
    message.write(_appLocalizations.shareTitle);
    message.writeln();
    message.writeln();
    message.writeln('🌺 *$_date*');
    message.writeln('📍 _$_daerah *($_negeri)*_');
    message.writeln('📆 ${_times.hijri}H');
    message.writeln();
    message.writeln(
        '```☁ ${_appLocalizations.fajrName.padRight(_padLength)}: ${_times.fajr.readable(_use12hourFormat)}```');
    message.writeln(
        '```🌞 ${_appLocalizations.dhuhrName.padRight(_padLength)}: ${_times.dhuhr.readable(_use12hourFormat)}```');
    message.writeln(
        '```☀ ${_appLocalizations.asrName.padRight(_padLength)}: ${_times.asr.readable(_use12hourFormat)}```');
    message.writeln(
        '```🌙 ${_appLocalizations.maghribName.padRight(_padLength)}: ${_times.maghrib.readable(_use12hourFormat)}```');
    message.writeln(
        '```⭐ ${_appLocalizations.ishaName.padRight(_padLength)}: ${_times.isha.readable(_use12hourFormat)}```');
    message.writeln();
    message.write(_appLocalizations.shareGetApp(envAppWebsite));

    return message.toString();
  }
}
