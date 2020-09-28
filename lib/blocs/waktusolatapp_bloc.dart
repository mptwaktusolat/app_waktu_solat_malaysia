import 'dart:async';
import 'package:waktusolatmalaysia/models/waktusolatappapi.dart';
import 'package:waktusolatmalaysia/networking/Response.dart';
import 'package:waktusolatmalaysia/repository/azanpro_repository.dart';

class WaktusolatappBloc {
  AzanTimesTodayRepository _prayerTimeRepository;
  StreamController _prayDataController;

  StreamSink<Response<WaktuSolatApp>> get prayDataSink =>
      _prayDataController.sink;

  Stream<Response<WaktuSolatApp>> get prayDataStream =>
      _prayDataController.stream;

  WaktusolatappBloc(String category, String format) {
    _prayDataController = StreamController<Response<WaktuSolatApp>>();
    _prayerTimeRepository = AzanTimesTodayRepository();
    // format = format == null ? '' : format;
    fetchPrayerTime(category, format);
  }

  fetchPrayerTime(String category, String format) async {
    prayDataSink.add(Response.loading('Getting prayer times'));
    try {
      WaktuSolatApp prayerTime =
          await _prayerTimeRepository.fetchAzanTodayWSA(category, format);
      prayDataSink.add(Response.completed(prayerTime));
    } catch (e) {
      prayDataSink.add(Response.error(e.toString()));
      print('Error caught: ' + e.toString());
    }
  }

  dispose() {
    _prayDataController?.close();
  }
}
