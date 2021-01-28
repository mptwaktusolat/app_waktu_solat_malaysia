// import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';

void main() {
  convertToEpoch();
}

void convertToEpoch() {
  // https://stackoverflow.com/a/63527239/13617136
  var time = "16:42:00";
  var date = "01-Jan-2021";
  var dateTime = date + ' ' + time;
  print(dateTime);

  var f = DateFormat('dd-MMM-yyyy hh:mm');

  var parsed = f.parse(dateTime);
  print(parsed.millisecondsSinceEpoch);
}

bool isTheSameMonth(int savedMillis) {
  var savedMonth = DateTime.fromMillisecondsSinceEpoch(savedMillis).month;

  var currentMonth = DateTime.now().month;
  return savedMonth == currentMonth;
}
