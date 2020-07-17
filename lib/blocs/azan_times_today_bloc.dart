import 'dart:async';
import 'package:waktusolatmalaysia/repository/azan_times_today_repository.dart';
import 'package:waktusolatmalaysia/networking/Response.dart';
import 'package:waktusolatmalaysia/models/azanproapi.dart';

class PrayTimeBloc {
  AzanTimesTodayRepository _prayerTimeRepository;
  StreamController _prayDataController;

  StreamSink<Response<PrayerTime>> get prayDataSink => _prayDataController.sink;

  Stream<Response<PrayerTime>> get prayDataStream => _prayDataController.stream;

  Prayloc(String category) {
    _prayDataController = StreamController<Response<PrayerTime>>();
    _prayerTimeRepository = AzanTimesTodayRepository();
    fetchPrayerTime(category);
  }

  fetchPrayerTime(String category) async {
    prayDataSink.add(Response.loading('Getting prayer times'));
    try {
      PrayerTime prayerTime =
          await _prayerTimeRepository.fetchAzanToday(category);
      prayDataSink.add(Response.completed(prayerTime));
    } catch (e) {
      prayDataSink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _prayDataController?.close();
  }
}
