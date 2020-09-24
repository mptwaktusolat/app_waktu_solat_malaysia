import 'dart:async';

import 'package:waktusolatmalaysia/models/mpti906api.dart';
import 'package:waktusolatmalaysia/networking/Response.dart';
import 'package:waktusolatmalaysia/repository/mptLocation_repository.dart';

class Mpti906Bloc {
  MptRepository _mptRepository;
  StreamController _mptDataController;

  StreamSink<Response<Mpti906>> get mptDataSink => _mptDataController.sink;

  Stream<Response<Mpti906>> get mptDataStream => _mptDataController.stream;

  Mpti906Bloc(double latitude, double longitude) {
    _mptDataController = StreamController<Response<Mpti906>>();
    _mptRepository = MptRepository();
    print('Bloc received $latitude and $longitude');
    fetchLocationData(latitude, longitude);
  }

  fetchLocationData(double lat, double long) async {
    mptDataSink.add(Response.loading('Getting prayer times'));
    try {
      Mpti906 locationJakim =
          await _mptRepository.fetchLocation(lat.toString(), long.toString());
      mptDataSink.add(Response.completed(locationJakim));
    } catch (e) {
      mptDataSink.add(Response.error(e.toString()));
      print('Error caught: ' + e.toString());
    }
  }

  dispose() {
    // _isStreaming = false;
    _mptDataController?.close();
  }
}
