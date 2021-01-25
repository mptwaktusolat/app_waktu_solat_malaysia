import 'package:flutter/material.dart';

///Pop until root
///https://stackoverflow.com/a/58158996/13617136

class CustomNavigatorPop {
  static popTo(BuildContext context, int pops) {
    var count = 0;
    Navigator.popUntil(context, (route) {
      return count++ == pops; //how many pops
    });
  }
}
