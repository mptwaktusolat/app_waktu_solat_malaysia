//ignore_for_file: avoid_print, unused_import, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'package:intl/intl.dart';
import 'package:waktusolatmalaysia/CONSTANTS.dart';

void main() {
  // var uri = Uri.https(kApiBaseUrl, 'api/zones/gps',
  //     {'lat': 3.1390.toString(), 'lang': 101.6869.toString()});
  // print(uri.toString());

  var now = DateTime(2023, 9);
  print(DateFormat('MMM').format(now));

  var monthName = 'May';
  print(DateFormat('MMM').parse(monthName).month);
}
