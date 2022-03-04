//ignore_for_file: avoid_print, unused_import

import 'dart:math';

import 'package:intl/intl.dart';
import 'lib/locationUtil/locationDatabase.dart';

enum Test { first, second }

void main() {
  var date = "04-Mar-2022";

  var _monthMap = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String pattern = 'd-M-y HH:mm:ss';

  // Changing Text month to its numeric equivalent
  // eg: 2-Okt-2021 will be 2-10-2021

  var _monthNumeric =
      _monthMap.indexWhere((element) => date.contains(element)) + 1;

  int end = _monthNumeric == 8 ? 7 : 6; // Only Ogos has 4 month character

  date = date.replaceRange(3, end, _monthNumeric.toString());

  var imsak = "06:11:00";

  print("pattern is $date $imsak");
}

void weekday() {
  print(DateTime.now().subtract(const Duration(days: 1)).weekday);
  print(DateTime.friday);
}

void updateCheck() {
  String version = '2.2.4-hotfix+80';

  var appBuildNum = version.split('+');

  print(int.parse(appBuildNum.last));
}

void datePattern() {
  String date = '15-Sep-2021 18:27:43';
  String pattern = 'd-MMM-y hh:mm:ss';
  var datetime = DateFormat(pattern).parse(date);
  print(datetime);
}

void listTest() {
  List _myList =
      List.generate(2, (index) => 'Item ${index + Random().nextInt(300)}');

  List _takeEnd = _myList.sublist(1);
  List _takeStart = _myList.take(5).toList(); // take first 5

  print(_myList);
  print('\n');
  print(_takeStart);
  print('\n');
  print(_takeEnd);
  print('\n');

  // print(_myList.getRange(0, 7));
}

void stringMultiline() {
  String message = 'Solat timetable: "_dayFormat", "_dateFormat"\n';
  message += '\n';
  message += '📍 "daerah" ("negeri")\n';
  message += '📆 ${"hijriToday"}H\n';
  message += '\n';
  message += "☁ Timothy Taylor: b119:d44e:9e33:1a29:35f5:fb42:327a:2960\n";
  message += "🌞 Dennis Walsh: 292c:c75a:8378:2251:eafb:03b4:8689:b379\n";
  message += "☀ Christina Bryan: f539:dcc8:35d8:495e:ff08:473b:5aff:e764\n";
  message += "🌙 Myrtle Kim: a7bd:b687:c4c6:9e0f:04ca:4e87:638c:59b1\n";
  message += "⭐ Dylan Sanchez: 8147:f110:3630:f616:d96d:284c:4aeb:946f\n";
  message += '\n';
  message += 'Get the app: meiow';

  print(message);
}
