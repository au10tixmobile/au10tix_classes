import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xffffd657, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffe6c14e), //10%
      100: Color(0xffccab46), //20%
      200: Color(0xffb3963d), //30%
      300: Color(0xff998034), //40%
      400: Color(0xff806b2c), //50%
      500: Color(0xff665623), //60%
      600: Color(0xff4c401a), //70%
      700: Color(0xff332b11), //80%
      800: Color(0xff191509), //90%
      900: Color(0xff000000), //100%
    },
  );
}
