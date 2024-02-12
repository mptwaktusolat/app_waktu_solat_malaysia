class HijriDate {
  /// List of full hijri names based on JAKIM
  final List<String> _hijriNames = [
    "Muharram",
    "Safar",
    "Rabi'ulawal",
    "Rabi'ulakhir",
    "Jamadilawwal",
    "Jamadilakhir",
    "Rejab",
    "Sya'ban",
    "Ramadhan",
    "Syawwal",
    "Zulkaedah",
    "Zulhijjah",
  ];

  /// List of shorthand hijri names based on JAKIM api
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

  /// Parse Hijri date from JAKIM API response
  HijriDate.parse(String hijriDate) {
    final date = hijriDate.split('-');

    year = int.parse(date.first);
    month = int.parse(date[1]);
    day = int.parse(date.last);
    monthName = _hijriNames[month - 1];
    shortMonthName = _shortHijriNames[month - 1];
  }

  @override
  String toString() {
    return "$day $monthName $year";
  }

  /// Example: 12 Jak 1453
  String dMY() {
    return "$day $shortMonthName $year";
  }

  /// Example: 12 Jak
  String dM() {
    return "$day $shortMonthName";
  }

  String dMMM() {
    return "$day $monthName";
  }
}
