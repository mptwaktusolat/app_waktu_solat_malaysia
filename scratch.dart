//ignore_for_file: avoid_print, unused_import, unused_local_variable, no_leading_underscores_for_local_identifiers

void main() {
  var mockPrayerTime = [
    DateTime(2023, 5, 16, 5, 10), //Imsak: 0
    DateTime(2023, 5, 16, 6, 10), // Subuh: 1
    DateTime(2023, 5, 16, 7, 10), // Syuruk: 2
    DateTime(2023, 5, 16, 8, 10), // Dhuha: 3
    DateTime(2023, 5, 16, 14, 10), // Zohor: 4
    DateTime(2023, 5, 16, 16, 30), // Asar: 5
    DateTime(2023, 5, 16, 19, 30), // Maghrib: 6
    DateTime(2023, 5, 16, 20, 30), // Isyak: 7
  ];

  var now = DateTime(2023, 5, 16, 6, 30);

  if (now.isAfter(mockPrayerTime[1]) && now.isBefore(mockPrayerTime[2])) {
    print("Subuh");
  } else if (now.isAfter(mockPrayerTime[4]) &&
      now.isBefore(mockPrayerTime[5])) {
    print("Zuhur");
  } else if (now.isAfter(mockPrayerTime[5]) &&
      now.isBefore(mockPrayerTime[6])) {
    print("Asar");
  } else if (now.isAfter(mockPrayerTime[6]) &&
      now.isBefore(mockPrayerTime[7])) {
    print("Maghrib");
  } else if (now.isAfter(mockPrayerTime[7]) &&
      now.isBefore(mockPrayerTime[1].add(const Duration(days: 1)))) {
    print('Isyak');
  }
}
