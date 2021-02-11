import 'dart:async';

import 'package:waktusolatmalaysia/models/jakim_prayer_model.dart';

import '../networking/Response.dart';
import '../repository/prayerTime_repository.dart';

class JakimPrayerBloc {
  AzanTimesTodayRepository _prayerTimeRepository;
  StreamController _prayDataController;

  StreamSink<Response<JakimPrayerModel>> get prayDataSink =>
      _prayDataController.sink;

  Stream<Response<JakimPrayerModel>> get prayDataStream =>
      _prayDataController.stream;

  JakimPrayerBloc(String location) {
    _prayDataController = StreamController<Response<JakimPrayerModel>>();
    _prayerTimeRepository = AzanTimesTodayRepository();

    fetchPrayerTime(location);
  }

  fetchPrayerTime(String location) async {
    prayDataSink.add(Response.loading('Getting prayer times'));
    try {
      JakimPrayerModel prayerTime =
          await _prayerTimeRepository.fetchPrayerMonth(location);
      prayDataSink.add(Response.completed(prayerTime));
    } catch (e) {
      prayDataSink.add(Response.error(e.toString()));
    }
  }

  dispose() {
    _prayDataController?.close();
  }
}
