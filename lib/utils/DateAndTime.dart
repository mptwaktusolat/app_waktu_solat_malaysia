import 'package:intl/intl.dart';

class DateAndTime {
  static String toAmPmReadable(int unix) {
    var format12 = DateFormat('h:mm a');
    var date =
        new DateTime.fromMillisecondsSinceEpoch(unix * 1000, isUtc: true);
    date = date.add(Duration(hours: 8)); //phone already formatted like this
    var formattedTime = format12.format(date);
    return (formattedTime);
  }

  //TODO: Setting to switch from 24 hour and 12 hour system
}
