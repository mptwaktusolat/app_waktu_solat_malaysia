import 'package:intl/intl.dart';

class DateAndTime {
  /// Convert epovh timestamp to human readable time
  static String toTimeReadable(int unix, bool is12hr) {
    var formatToReadable = is12hr ? DateFormat('h:mm a') : DateFormat('HH:mm');
    var date = DateTime.fromMillisecondsSinceEpoch(unix, isUtc: true);
    date =
        date.add(const Duration(hours: 8)); //phone already formatted like this
    var formattedTime = formatToReadable.format(date);
    return (formattedTime);
  }

  /// check if input date is in this month
  static bool isSameMonthFromMillis(int millis) {
    var savedMonth = DateTime.fromMillisecondsSinceEpoch(millis).month;

    var currentMonth = DateTime.now().month;
    return savedMonth == currentMonth;
  }

  /// Accept month in integer, for eg: 7 (for July) etc.
  static bool isSameMonthFromM(int? month) {
    return month == DateTime.now().month;
  }

  /// Accept year in int, for eg: 2021
  static bool isTheSameYear(int? year) {
    return year == DateTime.now().year;
  }

  ///Convert int month to month name
  static String monthName(int month, String locale) {
    // The year doesnt matter kot
    return DateFormat("MMMM", locale).format(DateTime(2021, month));
  }
}
