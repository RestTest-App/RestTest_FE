import 'package:flutter/material.dart';

abstract class ColorSystem {
  // Transparent Color
  static Color transparent = Colors.transparent;

  // White Color
  static Color white = Colors.white;

  // Black Color
  static Color black = const Color(0xFF181818);

  // Background Color
  static Color back = const Color(0xFFF5F5F5);

  // Light Color
  static Color lightBlue = const Color(0xFFEBF1F6);
  static Color lightGreen = const Color(0xFFEAF7ED);
  static Color lightRed = const Color(0xFFFDEEEE);
  static Color lightBrown = const Color(0xFFF1E9E3);

  // Selected Color
  static Color selectedBlue = const Color(0xFFF3F7FB);

  // Primary Color
  static const int _bluePrimaryValue = 0xFF0B60B0;
  static const int _greyPrimaryValue = 0xFF949494;

  // Secondary Color
  static Color deepBlue = const Color(0xFF0B2447);
  static Color brown = const Color(0xFFA27B5B);
  static Color red = const Color(0xFFF05454);
  static Color green = const Color(0xFF5DB177);

  static MaterialColor blue = const MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
      100: Color(0xFFCBEDFB), // 90% 밝게
      200: Color(0xFF9AD8F7), // 80% 밝게
      300: Color(0xFF65B5E7), // 70% 밝게
      400: Color(0xFF3D90CF), // 60% 밝게
      500: Color(_bluePrimaryValue), // 기본 색상
      600: Color(0xFF084A97), // 20% 어둡게
      700: Color(0xFF05377E), // 30% 어둡게
      800: Color(0xFF032766), // 40% 어둡게
      900: Color(0xFF021B54), // 50% 어둡게
    },
  );

  static MaterialColor grey = const MaterialColor(
    _greyPrimaryValue,
    <int, Color>{
      100: Color(0xFFFAFAFA), // 90% 밝게
      200: Color(0xFFE8E8E8), // 80% 밝게
      300: Color(0xFFD2D2D2), // 70% 밝게
      400: Color(0xFFB5B5B5), // 60% 밝게
      500: Color(_greyPrimaryValue), // 기본 색상
      600: Color(0xFF676767), // 20% 어둡게
      700: Color(0xFF05377E), // 30% 어둡게 -> 이거 쓰지말기
      800: Color(0xFF3F3F3F), // 40% 어둡게
      900: Color(0xFF021B54), // 50% 어둡게 -> 이거 쓰지말기
    },
  );


}