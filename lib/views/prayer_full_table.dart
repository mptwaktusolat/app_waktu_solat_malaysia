import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/mpt_server_solat.dart';
import '../networking/mpt_fetch_api.dart';
import '../providers/timetable_provider.dart';
import '../utils/date_and_time.dart';
import 'settings/full_prayer_table_settings.dart';

class PrayerFullTable extends StatelessWidget {
  PrayerFullTable({super.key});

  final GlobalKey<NestedScrollViewState> nestedScrollKey = GlobalKey();
  final int _todayIndex = DateTime.now().day - 1;
  final int _month = DateTime.now().month;
  final int _year = DateTime.now().year;
  final String _locationCode = GetStorage().read(kStoredLocationJakimCode);
  final bool _is12HourFormat = GetStorage().read(kStoredTimeIs12);

  // https://api.flutter.dev/flutter/widgets/NestedScrollViewState-class.html
  ScrollController get innerController {
    return nestedScrollKey.currentState!.innerController;
  }

  @override
  Widget build(BuildContext context) {
    // Scroll to today's date after page loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // delay a bit so user can see the scrol animation
      Future.delayed(const Duration(milliseconds: 500), () {
        innerController.animateTo(
          // according to the docs, each data row have height of [kMinInteractiveDimension],
          // so we just multiply with the day to get the offset
          kMinInteractiveDimension * _todayIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    });

    return Scaffold(
      // https://stackoverflow.com/questions/51948252/hide-appbar-on-scroll-flutter
      body: NestedScrollView(
        key: nestedScrollKey,
        headerSliverBuilder: (_, innerboxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).colorScheme.primary,
              floating: true,
              pinned: true,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(
                    start: 4, bottom: 16, end: 4),
                background: CachedNetworkImage(
                  imageUrl: Uri.https(kApiBaseUrl, '/api/mosque/$_locationCode')
                      .toString(),
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.7),
                  colorBlendMode: BlendMode.overlay,
                ),
                centerTitle: true,
                title: Text(
                    '${AppLocalizations.of(context)?.timetableTitle(DateAndTime.monthName(_month, AppLocalizations.of(context)!.localeName))} ($_locationCode)',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
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
              builder: (_, AsyncSnapshot<MptServerSolat> snapshot) {
                if (snapshot.hasData) {
                  return _PrayerDataTable(
                    todayIndex: _todayIndex,
                    model: snapshot.data!,
                    year: _year,
                    month: _month,
                    is12HourFormat: _is12HourFormat,
                  );
                }
                return Center(
                  child: SpinKitFadingCube(
                      size: 35, color: Theme.of(context).colorScheme.primary),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.timetableExportTooltip,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                return SizedBox(
                  height: 100,
                  child: FutureBuilder(
                      future: MptApiFetch.downloadJadualSolat(_locationCode),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Text(AppLocalizations.of(context)!
                                      .timetableExportSuccess),
                                  const Spacer(),
                                  ElevatedButton(
                                    onPressed: () {
                                      OpenFile.open(snapshot.data!.path);
                                      Navigator.pop(context);
                                    },
                                    child: Text(AppLocalizations.of(context)!
                                        .timetableExportOpen),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(AppLocalizations.of(context)!
                                .timetableExportError(
                                    snapshot.error.toString())),
                          );
                        }
                        return Center(
                          child: Text(AppLocalizations.of(context)!
                              .timetableExportExporting),
                        );
                      }),
                );
              });
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}

class _PrayerDataTable extends StatelessWidget {
  const _PrayerDataTable({
    required MptServerSolat model,
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
  final MptServerSolat _model;

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
                        day.format(_is12HourFormat),
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
                      '~${DateAndTime.nightOneThird(
                        _model.prayers[index].maghrib,
                        _model.prayers[index].fajr,
                      ).format(_is12HourFormat)}',
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
