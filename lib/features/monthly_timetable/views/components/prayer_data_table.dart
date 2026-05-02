import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../providers/timetable_provider.dart';
import '../../../../shared/extensions/date_time_extensions.dart';
import '../../../../shared/utils/date_time_utils.dart';
import '../monthly_timetable_settings.dart';

class PrayerDataTable extends StatelessWidget {
  const PrayerDataTable({
    super.key,
    required MPTWaktuSolatV2 model,
    required int todayIndex,
    required int year,
    required int month,
    required bool is12HourFormat,
  })  : _todayIndex = todayIndex,
        _model = model,
        _year = year,
        _month = month,
        _is12HourFormat = is12HourFormat;

  final int _todayIndex;
  final int _year;
  final int _month;
  final bool _is12HourFormat;
  final MPTWaktuSolatV2 _model;

  @override
  Widget build(BuildContext context) {
    return Consumer<TimetableProvider>(
      builder: (_, value, __) => DataTable(
        columnSpacing: 30,
        // Map of title and tooltip
        columns: {
          AppLocalizations.of(context)!.timetableDate: null,
          if (value.showHijri) "Hijri": null,
          AppLocalizations.of(context)!.imsakName:
              AppLocalizations.of(context)!.imsakDescription,
          AppLocalizations.of(context)!.fajrName: null,
          AppLocalizations.of(context)!.sunriseName:
              AppLocalizations.of(context)!.sunriseDescription,
          AppLocalizations.of(context)!.dhuhaName:
              AppLocalizations.of(context)!.dhuhaDescription,
          AppLocalizations.of(context)!.dhuhrName: null,
          AppLocalizations.of(context)!.asrName: null,
          AppLocalizations.of(context)!.maghribName: null,
          AppLocalizations.of(context)!.ishaName: null,
          if (value.showLastOneThirdNight)
            AppLocalizations.of(context)!.timetableOneThird: null,
        }
            .entries
            .map((e) => DataColumn(
                tooltip: e.value,
                label: Text(
                  e.key,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                )))
            .toList(),
        rows: List.generate(_model.prayers.length, (index) {
          return DataRow(
            selected: index == _todayIndex,
            cells: [
              DataCell(
                Text(
                  DateFormat(
                          'd/M (E)', AppLocalizations.of(context)?.localeName)
                      .format(
                    DateTime(_year, _month, index + 1),
                  ),
                  style: TextStyle(
                    fontWeight: index == _todayIndex ? FontWeight.bold : null,
                  ),
                ),
              ),
              if (value.showHijri)
                DataCell(
                  Text(
                    value.hijriStyle == HijriStyle.short
                        ? _model.prayers[index].hijri.dM()
                        : _model.prayers[index].hijri.dMMM(),
                    style: TextStyle(
                      fontWeight: index == _todayIndex ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ...[
                _model.prayers[index].imsak,
                _model.prayers[index].fajr,
                _model.prayers[index].syuruk,
                _model.prayers[index].dhuha,
                _model.prayers[index].dhuhr,
                _model.prayers[index].asr,
                _model.prayers[index].maghrib,
                _model.prayers[index].isha
              ].map(
                (day) => DataCell(
                  Center(
                    child: Opacity(
                      opacity: (index < _todayIndex) ? 0.55 : 1.0,
                      child: Text(
                        day.readable(_is12HourFormat),
                        style: TextStyle(
                            fontWeight:
                                index == _todayIndex ? FontWeight.bold : null),
                      ),
                    ),
                  ),
                ),
              ),
              if (value.showLastOneThirdNight)
                DataCell(
                  Opacity(
                    opacity: (index < _todayIndex) ? 0.55 : 1.0,
                    child: Text(
                      '~${DateTimeUtil.nightOneThird(
                        _model.prayers[index].maghrib,
                        _model.prayers[index].fajr,
                      ).readable(_is12HourFormat)}',
                      style: TextStyle(
                          fontWeight:
                              index == _todayIndex ? FontWeight.bold : null),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
