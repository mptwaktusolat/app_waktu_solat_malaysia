import 'package:flutter/material.dart';

/// gradients from https://uigradients.com/
class TasbihColors {
  TasbihColors._();

  static const List<Color> _betweenNightAndDay = [
    Color(0xff2c3e50),
    Color(0xff3498db),
  ];

  static const List<Color> _blush = [
    Color(0xffB24592),
    Color(0xffF15F79),
  ];

  static const List<Color> _timber = [
    Color(0xfffc00ff),
    Color(0xff00dbde),
  ];

  static const List<Color> _flickr = [
    Color(0xff00bf8f),
    Color(0xff001510),
  ];

  static const List<Color> _vine = [
    Color(0xffff0084),
    Color(0xff33001b),
  ];

  static const List<Color> _predown = [
    Color(0xffFFA17F),
    Color(0xff00223E),
  ];

  static const List<Color> _poncho = [
    Color(0xff403A3E),
    Color(0xffBE5869),
  ];

  static List<List<Color>> gradientColour() =>
      [_betweenNightAndDay, _blush, _timber, _flickr, _vine, _predown, _poncho];
}
