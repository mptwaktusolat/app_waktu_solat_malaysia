import 'dart:async';
import 'package:waktusolatmalaysia/models/groupedzoneapi.dart';
import 'package:waktusolatmalaysia/repository/azan_times_today_repository.dart';
import 'package:waktusolatmalaysia/networking/Response.dart';
import 'package:waktusolatmalaysia/models/azanproapi.dart';

class ZoneBloc {
  AzanTimesTodayRepository _zoneRepository;
  StreamController _zoneController;
  bool _isStreaming;

  StreamSink<Response<GroupedZones>> get zoneDataSink => _zoneController.sink;

  Stream<Response<GroupedZones>> get zoneDataStream => _zoneController.stream;

  zoneBloc() {
    _zoneController = StreamController<Response<PrayerTime>>();
    _zoneRepository = AzanTimesTodayRepository();
    _isStreaming = true;
    fetchZone();
  }

  fetchZone() async {
    zoneDataSink.add(Response.loading('Getting available zones'));
    try {
      GroupedZones groupedZones = await _zoneRepository.fetchGroupedZones();
      zoneDataSink.add(Response.completed(groupedZones));
    } catch (e) {
      zoneDataSink.add(Response.error(e.toString()));
      print('Error caught: ' + e);
    }
  }

  dispose() {
    _isStreaming = false;
    _zoneController?.close();
  }
}
