import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = Color(0xff1f1f1f);
  static Color lightAccent = Color(0xff00b894);
  static Color darkAccent = Color(0xff00b894);
  static Color lightBG = Colors.white;
  static Color darkBG = Color(0xff121212);
  static Color lightGreyLine = Color(0xffeeeeee);
  static Color darkGreyLine = Color(0xff1f1f1f);

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    accentColor: lightAccent,
    // cursorColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ),
    dividerColor: lightGreyLine,
    dialogBackgroundColor: darkGreyLine,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: Color(0xff333333),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
    ),
    dividerColor: darkGreyLine,
    dialogBackgroundColor: darkGreyLine,
  );
}
