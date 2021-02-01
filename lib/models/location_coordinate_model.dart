import 'package:flutter/cupertino.dart';

class LocationCoordinateData {
  String zone;
  String negeri;
  String lokasi;
  double lat;
  double lng;
  LocationCoordinateData(
      {@required this.zone,
      @required this.negeri,
      @required this.lokasi,
      @required this.lat,
      @required this.lng});
}
