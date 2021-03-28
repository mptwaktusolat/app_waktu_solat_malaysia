import 'dart:async';

import '../models/mpti906PrayerData.dart';
import '../networking/Response.dart';
import '../repository/prayerTime_repository.dart';

class Mpti906PrayerBloc {
  AzanTimesTodayRepository _prayerTimeRepository;
  StreamController _prayDataController;

  StreamSink<Response<Mpti906PrayerModel>> get prayDataSink =>
      _prayDataController.sink;

  Stream<Response<Mpti906PrayerModel>> get prayDataStream =>
      _prayDataController.stream;

  Mpti906PrayerBloc(String location) {
    _prayDataController = StreamController<Response<Mpti906PrayerModel>>();
    _prayerTimeRepository = AzanTimesTodayRepository();

    fetchPrayerTime(location);
  }

  fetchPrayerTime(String location) async {
    prayDataSink.add(Response.loading('Getting prayer times'));
    try {
      Mpti906PrayerModel prayerTime =
          await _prayerTimeRepository.fetchAzanMptMonth(location);
      prayDataSink.add(Response.completed(prayerTime));
    } catch (e) {
      prayDataSink.add(Response.error(e.toString()));
    }
  }

  dispose() {
    _prayDataController?.close();
  }
}
