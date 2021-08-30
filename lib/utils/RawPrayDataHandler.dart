final int day = DateTime.now().day;

class PrayDataHandler {
  /// return prayer times for today and the future, past days are removed
  static List<List<dynamic>> removePastDate(List<List<dynamic>> times) =>
      times.sublist(day - 1);

  static List<dynamic> todayPrayData(List<List<dynamic>> times) =>
      times[day - 1];
}
