import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/models/jakim_esolat_model.dart';
import '../locationUtil/locationDatabase.dart';
import '../utils/DateAndTime.dart';
import '../utils/mpt_fetch_api.dart';
import '../CONSTANTS.dart';

class PrayerFullTable extends StatelessWidget {
  PrayerFullTable({Key? key}) : super(key: key);
  final int todayIndex = DateTime.now().day - 1;
  final int month = DateTime.now().month;
  final int year = DateTime.now().year;
  final int? locationIndex = GetStorage().read(kStoredGlobalIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // https://stackoverflow.com/questions/51948252/hide-appbar-on-scroll-flutter
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerboxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              expandedHeight: 130,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl:
                      'https://i2.wp.com/news.iium.edu.my/wp-content/uploads/2017/06/10982272836_29abebc100_b.jpg?ssl=1',
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.4),
                  colorBlendMode: BlendMode.overlay,
                ),
                centerTitle: true,
                title: Text(
                  '${DateAndTime.monthName(month)} timetable (${LocationDatabase.getJakimCode(locationIndex!)})',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ];
        },
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: FutureBuilder(
              future: MptApiFetch.fetchMpt(
                LocationDatabase.getJakimCode(
                  locationIndex!,
                ),
              ),
              builder: (context, AsyncSnapshot<JakimEsolatModel> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SpinKitFadingCube(size: 35, color: Colors.teal));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error as String);
                } else if (snapshot.hasData) {
                  return DataTable(
                    columnSpacing: 30,
                    // Map of title and tooltip
                    columns: {
                      'Date': null,
                      'Imsak': '10 minutes before Subuh',
                      'Subuh': null,
                      'Syuruk': 'Sunrise',
                      'Dhuha': '28 Minutes After Syuruk Time (Sunrise)',
                      'Zohor': null,
                      'Asar': null,
                      'Maghrib': null,
                      'Isyak': null,
                    }
                        .entries
                        .map((e) => DataColumn(
                            tooltip: e.value,
                            label: Text(
                              e.key,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            )))
                        .toList(),
                    rows: List.generate(snapshot.data!.prayerTime!.length,
                        (index) {
                      return DataRow(selected: index == todayIndex, cells: [
                        DataCell(
                          Text(
                            DateFormat('d / M (E)')
                                .format(DateTime(year, month, index + 1)),
                            style: TextStyle(
                                fontWeight: index == todayIndex
                                    ? FontWeight.bold
                                    : null),
                          ),
                        ),
                        ...snapshot.data!.prayerTime![index].times!
                            .map((day) => DataCell(
                                  Center(
                                    child: Opacity(
                                      opacity:
                                          (index < todayIndex) ? 0.55 : 1.0,
                                      child: Text(
                                        DateAndTime.toTimeReadable(day, true),
                                        style: TextStyle(
                                            fontWeight: index == todayIndex
                                                ? FontWeight.bold
                                                : null),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList()
                      ]);
                    }),
                  );
                } else {
                  return const Text('ERROR!');
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
