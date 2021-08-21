//ignore_for_file: avoid_print

import 'dart:math';

void main() {
  var _num = DateTime.fromMillisecondsSinceEpoch(1629117480 * 1000)
      .millisecondsSinceEpoch;
  int _newNum = int.parse(_num.toString().substring(5));
  print(_newNum);
  if (_newNum < pow(2, 31)) print('In range');
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
