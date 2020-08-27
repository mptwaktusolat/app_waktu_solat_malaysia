import 'dart:async';
import 'package:waktusolatmalaysia/repository/azan_times_today_repository.dart';
import 'package:waktusolatmalaysia/networking/Response.dart';
import 'package:waktusolatmalaysia/models/azanproapi.dart';

class PrayTimeBloc {
  AzanTimesTodayRepository _prayerTimeRepository;
  StreamController _prayDataController;
  bool _isStreaming;

  StreamSink<Response<PrayerTime>> get prayDataSink => _prayDataController.sink;

  Stream<Response<PrayerTime>> get prayDataStream => _prayDataController.stream;

  PrayTimeBloc(String category, String format) {
    _prayDataController = StreamController<Response<PrayerTime>>();
    _prayerTimeRepository = AzanTimesTodayRepository();
    _isStreaming = true;
    fetchPrayerTime(category, format);
  }

  fetchPrayerTime(String category, String format) async {
    prayDataSink.add(Response.loading('Getting prayer times'));
    try {
      PrayerTime prayerTime =
          await _prayerTimeRepository.fetchAzanToday(category, format);
      prayDataSink.add(Response.completed(prayerTime));
    } catch (e) {
      prayDataSink.add(Response.error(e.toString()));
      print('Error caught: ' + e.toString());
    }
  }

  dispose() {
    _isStreaming = false;
    _prayDataController?.close();
  }
}
