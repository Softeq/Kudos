import 'package:flutter/material.dart';

class KudosTheme {
  static Color get textColor => Colors.white;

  static Color get accentColor => Color.fromARGB(255, 3, 218, 197);

  static Color get contentColor => Colors.white;

  static Color get mainGradientStartColor => Color.fromARGB(255, 106, 24, 163);

  static Color get mainGradientEndColor => Color.fromARGB(255, 57, 38, 179);

  static TextStyle get appBarTitleTextStyle => TextStyle(
    fontSize: 20.0,
    color: Colors.white,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get userNameTitleTextStyle => TextStyle(
        fontSize: 20.0,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get userNameSubTitleTextStyle => TextStyle(
        fontSize: 14.0,
        color: Color.fromARGB(160, 255, 255, 255),
        fontWeight: FontWeight.w500,
      );

  static TextStyle get listTitleTextStyle => TextStyle(
        fontSize: 16.0,
        color: mainGradientEndColor,
        fontWeight: FontWeight.w800,
      );

  static TextStyle get listSubTitleTextStyle => TextStyle(
        fontSize: 14.0,
        color: Color.fromRGBO(189, 189, 189, 1),
      );
}
