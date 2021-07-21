final int day = DateTime.now().day;

class PrayDataHandler {
  static List<dynamic> removePastDate(List<List<dynamic>> times) {
    List<dynamic> _temp = [];
    for (int i = 0; i < times.length; i++) {
      //ignore the previous date
      if (!(i < day - 1)) {
        _temp.add(times[i]);
      }
    }
    // return today and future dates only
    return _temp;
  }

  static List<dynamic> todayPrayData(List<List<dynamic>> times) =>
      times[day - 1];
}
