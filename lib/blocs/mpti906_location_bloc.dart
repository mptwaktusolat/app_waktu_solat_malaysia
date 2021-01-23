import 'dart:async';

import '../models/mpti906api_location.dart';
import '../networking/Response.dart';
import '../repository/mptLocation_repository.dart';

class Mpti906LocationBloc {
  MptRepository _mptRepository;
  StreamController _mptDataController;

  StreamSink<Response<Mpti906Location>> get mptDataSink =>
      _mptDataController.sink;

  Stream<Response<Mpti906Location>> get mptDataStream =>
      _mptDataController.stream;

  Mpti906LocationBloc(double latitude, double longitude) {
    _mptDataController = StreamController<Response<Mpti906Location>>();
    _mptRepository = MptRepository();
    print('Bloc received $latitude and $longitude');
    fetchLocationData(latitude, longitude);
  }

  fetchLocationData(double lat, double long) async {
    mptDataSink.add(Response.loading('Getting location data'));
    try {
      Mpti906Location locationJakim =
          await _mptRepository.fetchLocation(lat.toString(), long.toString());
      mptDataSink.add(Response.completed(locationJakim));
    } catch (e) {
      mptDataSink.add(Response.error(e.toString()));
      print('Error caught: ' + e.toString());
    }
  }

  dispose() {
    _mptDataController?.close();
  }
}
