import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../blocs/mpti906_prayer_bloc.dart';
import '../models/mpti906PrayerData.dart';
import '../networking/Response.dart';
import '../utils/DateAndTime.dart';
import '../utils/location/locationDatabase.dart';
import '../CONSTANTS.dart';

class FullPrayerTable extends StatelessWidget {
  FullPrayerTable({Key key}) : super(key: key);
  final int locationIndex = GetStorage().read(kStoredGlobalIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'This month timetable (${LocationDatabase.getJakimCode(locationIndex)})'),
        centerTitle: true,
      ),
      body: StreamBuilder<Response<Mpti906PrayerModel>>(
        stream: Mpti906PrayerBloc(LocationDatabase.getMptLocationCode(
                GetStorage().read(kStoredGlobalIndex)))
            .prayDataStream,
        builder:
            (context, AsyncSnapshot<Response<Mpti906PrayerModel>> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(
                  child: const SpinKitFadingCube(size: 35, color: Colors.teal),
                );
                break;
              case Status.COMPLETED:
                return PrayerDataTable(model: snapshot.data.data);
                break;
              case Status.ERROR:
                return Container(color: Colors.redAccent, child: Text('Error'));
                break;
            }
          }
          return Container(
            child: Text('Uh it supposed not showing here'),
          );
        },
      ),
    );
  }
}

class PrayerDataTable extends StatelessWidget {
  PrayerDataTable({
    Key key,
    @required this.model,
  }) : super(key: key);

  final int todayIndex = DateTime.now().day - 1;
  final Mpti906PrayerModel model;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns:
              ['Date', 'Subuh', 'Syuruk', 'Zohor', 'Asar', 'Maghrib', 'Isyak']
                  .map(
                    (text) => DataColumn(
                        label: Text(
                      text,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    )),
                  )
                  .toList(),
          // columnSpacing: MediaQuery.of(context).size.width / 10,
          // columnSpacing: 30,
          rows: List.generate(model.data.times.length, (index) {
            return DataRow(selected: index == todayIndex, cells: [
              DataCell(Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.teal.shade50
                        : Colors.teal.shade900,
                    borderRadius: BorderRadius.circular(3.0)),
                child: Text(
                  '${index + 1} / ${model.data.month} (${DateFormat('E').format(DateTime(model.data.year, model.data.month, index + 1))})',
                  style: index == todayIndex
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : null,
                ),
              )),
              ...model.data.times[index].map((day) {
                return DataCell(Center(
                  child: Opacity(
                      opacity: (index < todayIndex) ? 0.60 : 1.0,
                      child: Text(
                        DateAndTime.toTimeReadable(day, true),
                        style: index == todayIndex
                            ? TextStyle(fontWeight: FontWeight.bold)
                            : null,
                      )),
                ));
              }).toList(),
            ]);
          }),
        ),
      ),
    );
  }
}
