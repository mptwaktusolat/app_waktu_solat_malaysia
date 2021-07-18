import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:waktusolatmalaysia/locationUtil/locationDatabase.dart';
import 'package:waktusolatmalaysia/models/mpti906PrayerData.dart';
import 'package:waktusolatmalaysia/utils/DateAndTime.dart';
import 'package:waktusolatmalaysia/utils/mpt_fetch_api.dart';

import '../CONSTANTS.dart';

class PrayerFullTable extends StatelessWidget {
  PrayerFullTable({Key key}) : super(key: key);
  final int today = DateTime.now().day;
  final int month = DateTime.now().month;
  final int locationIndex = GetStorage().read(kStoredGlobalIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${DateAndTime.monthName(month)} timetable (${LocationDatabase.getJakimCode(locationIndex)})'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: MptApiFetch.fetchMpt(
              LocationDatabase.getMptLocationCode(
                locationIndex,
              ),
            ),
            builder: (context, AsyncSnapshot<Mpti906PrayerModel> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SpinKitFadingCube(size: 35, color: Colors.teal);
              } else if (snapshot.hasError) {
                return Text(snapshot.error);
              } else if (snapshot.hasData) {
                return DataTable(
                  columns: [
                    'Date',
                    'Subuh',
                    'Imsak',
                    'Zohor',
                    'Asar',
                    'Maghrib',
                    'Isyak'
                  ]
                      .map(
                        (text) => DataColumn(
                            label: Text(
                          text,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        )),
                      )
                      .toList(),
                  rows: List.generate(snapshot.data.data.times.length, (index) {
                    return DataRow(selected: index == today - 1, cells: [
                      DataCell(
                          Text('${index + 1} / ${snapshot.data.data.month}')),
                      ...snapshot.data.data.times[index].map((day) {
                        return DataCell(Center(
                          child: Opacity(
                              opacity: (index < today - 1) ? 0.60 : 1.0,
                              child:
                                  Text(DateAndTime.toTimeReadable(day, true))),
                        ));
                      }).toList(),
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
    );
  }
}
