import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../CONSTANTS.dart';
import '../models/jakim_esolat_model.dart';
import '../networking/mpt_fetch_api.dart';
import '../providers/timetable_provider.dart';
import '../utils/date_and_time.dart';
import 'Settings part/full_prayer_table_settings.dart';

class PrayerFullTable extends StatelessWidget {
  PrayerFullTable({Key? key}) : super(key: key);
  final int _todayIndex = DateTime.now().day - 1;
  final int _month = DateTime.now().month;
  final int _year = DateTime.now().year;
  final String _locationCode = GetStorage().read(kStoredLocationJakimCode);
  final bool _is12HourFormat = GetStorage().read(kStoredTimeIs12);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // https://stackoverflow.com/questions/51948252/hide-appbar-on-scroll-flutter
      body: NestedScrollView(
        headerSliverBuilder: (_, innerboxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              expandedHeight: 130,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl:
                      'https://mpt-server.vercel.app/api/mosque/$_locationCode',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.7),
                  colorBlendMode: BlendMode.overlay,
                ),
                centerTitle: true,
                title: Text(
                  '${AppLocalizations.of(context)?.timetableTitle(DateAndTime.monthName(_month, AppLocalizations.of(context)!.localeName))} ($_locationCode)',
                  textAlign: TextAlign.center,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(
                            name: 'Prayer Timetable Settings'),
                        builder: (_) => const FullPrayerTableSettings(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                )
              ],
            )
          ];
        },
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
              future: MptApiFetch.fetchMpt(_locationCode),
              builder: (_, AsyncSnapshot<JakimEsolatModel> snapshot) {
                if (snapshot.hasData) {
                  return _PrayerDataTable(
                    todayIndex: _todayIndex,
                    model: snapshot.data!,
                    year: _year,
                    month: _month,
                    is12HourFormat: _is12HourFormat,
                  );
                }
                return const Center(
                  child: SpinKitFadingCube(size: 35, color: Colors.teal),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PrayerDataTable extends StatelessWidget {
  const _PrayerDataTable({
    Key? key,
    required JakimEsolatModel model,
    required int todayIndex,
    required int year,
    required int month,
    required bool is12HourFormat,
  })  : _todayIndex = todayIndex,
        _model = model,
        _year = year,
        _month = month,
        _is12HourFormat = is12HourFormat,
        super(key: key);

  final int _todayIndex;
  final int _year;
  final int _month;
  final bool _is12HourFormat;
  final JakimEsolatModel _model;

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
        rows: List.generate(_model.prayerTime!.length, (index) {
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
                        ? _model.prayerTime![index].hijri.dM()
                        : _model.prayerTime![index].hijri.dMMM(),
                    style: TextStyle(
                      fontWeight: index == _todayIndex ? FontWeight.bold : null,
                    ),
                  ),
                ),
              ...[
                _model.prayerTime![index].imsak,
                _model.prayerTime![index].fajr,
                _model.prayerTime![index].syuruk,
                _model.prayerTime![index].dhuha,
                _model.prayerTime![index].dhuhr,
                _model.prayerTime![index].asr,
                _model.prayerTime![index].maghrib,
                _model.prayerTime![index].isha
              ]
                  .map(
                    (day) => DataCell(
                      Center(
                        child: Opacity(
                          opacity: (index < _todayIndex) ? 0.55 : 1.0,
                          child: Text(
                            day.format(_is12HourFormat),
                            style: TextStyle(
                                fontWeight: index == _todayIndex
                                    ? FontWeight.bold
                                    : null),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              if (value.showLastOneThirdNight)
                DataCell(Opacity(
                  opacity: (index < _todayIndex) ? 0.55 : 1.0,
                  child: Text(
                    '~${DateAndTime.nightOneThird(
                      _model.prayerTime![index].maghrib,
                      _model.prayerTime![index].fajr,
                    ).format(_is12HourFormat)}',
                    style: TextStyle(
                        fontWeight:
                            index == _todayIndex ? FontWeight.bold : null),
                  ),
                )),
            ],
          );
        }),
      ),
    );
  }
}
