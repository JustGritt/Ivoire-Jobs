import 'package:flutter/material.dart';

class AppColors {
  static const int _black = 0xFF222831;
  static const int _white = 0xFFEEEEEE;
  static const MaterialColor black = MaterialColor(_black, {
    500: Color(_black),
  });
  static const MaterialColor white = MaterialColor(_white, {
    500: Color(_white),
  });

  static const int _space = 0xFF393E46;
  static const MaterialColor space = MaterialColor(_space, {
    400: Color(0xFF424242),
    500: Color(_space),
  });

  static const Color grey = Color.fromARGB(228, 161, 161, 161);

  static const int _teal = 0xFF00ADB5;
  static const MaterialColor teal = MaterialColor(
    _teal,
    <int, Color>{
      50: Color(0xFFE0F7FA),
      100: Color(0xFFB2EBF2),
      200: Color(0xFF80DEEA),
      300: Color(0xFF4DD0E1),
      400: Color(0xFF26C6DA),
      500: Color(_teal),
      600: Color(0xFF00ACC1),
      700: Color(0xFF0097A7),
      800: Color(0xFF00838F),
      900: Color(0xFF006064),
    },
  );
}
