//ignore_for_file: avoid_print

import 'dart:math';

import 'package:intl/intl.dart';
import 'lib/locationUtil/locationDatabase.dart';

enum Test { first, second }

void main() {
  print(LocationDatabase.daerah('prk03'));
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
