//ignore_for_file: avoid_print

import 'dart:math';

enum Test { first, second }

void main() {}

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
