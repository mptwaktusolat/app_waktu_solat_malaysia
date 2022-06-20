//ignore_for_file: avoid_print, unused_import, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:intl/intl.dart';
import 'lib/locationUtil/locationDatabase.dart';

enum Test { first, second }

void main() {
  print(Test.first.index);
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
