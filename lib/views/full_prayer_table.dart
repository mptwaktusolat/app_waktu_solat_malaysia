import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
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

  final int today = DateTime.now().day;
  final Mpti906PrayerModel model;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns:
              ['Date', 'Subuh', 'Imsak', 'Zohor', 'Asar', 'Maghrib', 'Isyak']
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
            return DataRow(selected: index == today - 1, cells: [
              DataCell(Text('${index + 1} / ${model.data.month}')),
              ...model.data.times[index].map((day) {
                return DataCell(Center(
                  child: Opacity(
                      opacity: (index < today - 1) ? 0.60 : 1.0,
                      child: Text(DateAndTime.toTimeReadable(day, true))),
                ));
              }).toList(),
            ]);
          }),
        ),
      ),
    );
  }
}
