import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:waktusolat_api_client/waktusolat_api_client.dart';

import '../../../constants.dart';
import '../../../env.dart';
import '../../../l10n/app_localizations.dart';
import '../../../networking/mpt_fetch_api.dart';
import '../../../providers/timetable_provider.dart';
import '../../../shared/extensions/date_time_extensions.dart';
import '../../../shared/utils/date_time_utils.dart';
import '../components/pdf_timetable_download_sheet.dart';
import 'monthly_timetable_settings.dart';

class MonthlyTimetablePage extends StatefulWidget {
  const MonthlyTimetablePage({super.key});

  @override
  State<MonthlyTimetablePage> createState() => _MonthlyTimetablePageState();
}

class _MonthlyTimetablePageState extends State<MonthlyTimetablePage> {
  final GlobalKey<NestedScrollViewState> nestedScrollKey = GlobalKey();
  late final Future<MPTWaktuSolatV2> _waktuSolatDataFuture;

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
  void initState() {
    super.initState();

    _waktuSolatDataFuture = MptApiFetch.fetchMpt(_locationCode);
    // Scroll to today's date after timetable loaded
    _waktuSolatDataFuture.then((_) => _scrollToToday());
  }

  void _scrollToToday() {
    // delay a bit so user can see the scroll animation
    Future.delayed(Duration(milliseconds: 850), () {
      // Day 1 most probably always visible, so don't animate if it's Day 1
      if (_todayIndex == 0) return;
      innerController.animateTo(
        // Each data row have height of [kMinInteractiveDimension],
        // so we just multiply with the day to get the offset
        kMinInteractiveDimension * (_todayIndex - 1),
        duration: Durations.long4,
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // https://stackoverflow.com/questions/51948252/hide-appbar-on-scroll-flutter
      body: NestedScrollView(
        key: nestedScrollKey,
        headerSliverBuilder: (_, innerboxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              pinned: true,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsetsDirectional.only(
                    start: 4, bottom: 16, end: 4),
                background: CachedNetworkImage(
                  imageUrl:
                      Uri.https(envApiBaseHost, '/api/mosque/$_locationCode')
                          .toString(),
                  fit: BoxFit.cover,
                  color: Colors.black.withValues(alpha: 0.7),
                  colorBlendMode: switch (Theme.of(context).brightness) {
                    Brightness.light => BlendMode.dstATop,
                    Brightness.dark => BlendMode.multiply,
                  },
                ),
                centerTitle: true,
                title: Text(
                    '${AppLocalizations.of(context)?.timetableTitle(DateTimeUtil.monthName(_month, AppLocalizations.of(context)!.localeName))} ($_locationCode)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    )),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: const RouteSettings(
                            name: 'Prayer Timetable Settings'),
                        builder: (_) => const MonthlyTimetableSettings(),
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
              future: _waktuSolatDataFuture,
              builder: (_, AsyncSnapshot<MPTWaktuSolatV2> snapshot) {
                if (snapshot.hasData) {
                  return _PrayerDataTable(
                    todayIndex: _todayIndex,
                    model: snapshot.data!,
                    year: _year,
                    month: _month,
                    is12HourFormat: _is12HourFormat,
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snapshot.error.toString()),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: SpinKitFadingCube(
                    size: 35,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      // Export PDF timetable button
      floatingActionButton: FloatingActionButton(
        tooltip: AppLocalizations.of(context)!.timetableExportTooltip,
        onPressed: () => openPdfTimetableDownloadSheet(context, _locationCode),
        child: const Icon(Icons.download),
      ),
    );
  }
}

class _PrayerDataTable extends StatelessWidget {
  const _PrayerDataTable({
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
