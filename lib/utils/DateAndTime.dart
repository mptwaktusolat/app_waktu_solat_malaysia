import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class DateAndTime {
  static String toTimeReadable(int unix, bool is12hr) {
    var formatToReadable = is12hr ? DateFormat('h:mm a') : DateFormat('HH:mm');
    var date = new DateTime.fromMillisecondsSinceEpoch(unix, isUtc: true);
    date = date.add(Duration(hours: 8)); //phone already formatted like this
    var formattedTime = formatToReadable.format(date);
    return (formattedTime);
  }

  static bool isTheSameMonth(int savedMillis) {
    var savedMonth = DateTime.fromMillisecondsSinceEpoch(savedMillis).month;

    var currentMonth = DateTime.now().month;
    return savedMonth == currentMonth;
  }

  /// Convert [01-Jan-2021 16:42:00] to [1609490520000], offset default to zero
  static int convertToEpoch(
      {@required String date,
      @required String time,
      Duration offset = Duration.zero}) {
    // https://stackoverflow.com/a/63527239/13617136
    var dateTime = date + ' ' + time;

    var f = DateFormat('dd-MMM-yyyy HH:mm'); //HH for 24, hh for 12

    var parsed = f.parse(dateTime);
    return parsed.millisecondsSinceEpoch + offset.inMilliseconds;
  }
}
