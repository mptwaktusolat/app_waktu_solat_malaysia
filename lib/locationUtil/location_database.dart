import '../models/jakim_zones.dart';

class LocationDatabase {
  static late List<JakimZones> allLocation;

  static int indexOfLocation(String jakimCode) =>
      allLocation.indexWhere((element) => element.jakimCode == jakimCode);

  static String negeri(String jakimCode) {
    jakimCode = jakimCode.toUpperCase();
    var res = allLocation.where((element) => element.jakimCode == jakimCode);

    if (res.isEmpty) {
      throw 'Not found. Check location code if entered correctly.';
    }

    return res.first.negeri;
  }

  static daerah(String jakimCode) {
    jakimCode = jakimCode.toUpperCase();
    var res = allLocation.where((element) => element.jakimCode == jakimCode);

    if (res.isEmpty) {
      throw 'Not found. Check location code if entered correctly.';
    }

    return res.first.daerah;
  }
}
