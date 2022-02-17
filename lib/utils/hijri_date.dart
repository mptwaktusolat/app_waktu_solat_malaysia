class HijriDate {
  final List<String> _hijriNames = [
    "Muharram",
    "Safar",
    "Rabi'ulawwal",
    "Rabi'ulakhir",
    "Jamadilawwal",
    "Jamadilakhir",
    "Rejab",
    "Sya'ban",
    "Ramadhan",
    "Syawal",
    "Zulqa'idah",
    "Zulhijjah",
  ];
  final List<String> _shortHijriNames = [
    "Muh",
    "Saf",
    "Raw",
    "Rak",
    "Jaw",
    "Jak",
    "Rej",
    "Syb",
    "Ram",
    "Syw",
    "Zkh",
    "Zhj",
  ];
  late int day, month, year;
  late String monthName;
  late String shortMonthName;

  HijriDate.fromJson(String hijriDate) {
    var _date = hijriDate.split('-');

    year = int.parse(_date.first);
    month = int.parse(_date[1]);
    day = int.parse(_date.last);
    monthName = _hijriNames[month - 1];
    shortMonthName = _shortHijriNames[month - 1];
  }

  @override
  String toString() {
    return "$day $monthName $year";
  }
}
