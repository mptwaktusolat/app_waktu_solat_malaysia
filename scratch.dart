// import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';

void main() {
  var now = DateTime.now();
  // print(month);
  print(now.year);
}

Uri uriHttps() {
  return Uri.https("www.e-solat.gov.my", "/index.php",
      {"r": "esolatApi/takwimsolat", "period": "month", "zone": "SGR01"});
}

int convertToEpoch(
    {String date, String time, Duration offset = Duration.zero}) {
  // https://stackoverflow.com/a/63527239/13617136
  var dateTime = date + ' ' + time;
  print('dateTime is $dateTime'); //01-Jan-2021 16:42:00

  var f = DateFormat('dd-MMM-yyyy hh:mm');

  var parsed = f.parse(dateTime);
  return parsed.millisecondsSinceEpoch + offset.inMilliseconds;
}

bool isTheSameMonth(int savedMillis) {
  var savedMonth = DateTime.fromMillisecondsSinceEpoch(savedMillis).month;

  var currentMonth = DateTime.now().month;
  return savedMonth == currentMonth;
}
