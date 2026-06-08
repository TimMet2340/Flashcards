import 'package:flutter/material.dart';

// Define the app's light and dark themes here.
final Color _lightPurple = const Color.fromARGB(255, 191, 169, 243);
final Color _lightAppBar = const Color.fromARGB(255, 235, 235, 235);
final Color _cardShadow = const Color.fromARGB(125, 87, 83, 83);
final Color _markerGreen = const Color(0xff137D20);
final Color _markerRed = const Color(0xffCE0F22);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.deepPurple,
    onPrimary: Colors.white,
    secondary: _markerGreen,
    onSecondary: Colors.white,
    error: _markerRed,
    onError: Colors.white,
    background: _lightPurple,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
    tertiary: _lightAppBar,
    shadow: _cardShadow,
  ),
  scaffoldBackgroundColor: _lightPurple,
  appBarTheme: AppBarTheme(
    backgroundColor: _lightAppBar,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
  cardColor: Colors.white,
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.deepPurpleAccent,
    onPrimary: Colors.black,
    secondary: _markerGreen,
    onSecondary: Colors.black,
    error: _markerRed,
    onError: Colors.black,
    background: Color(0xFF1B1226), // dark purple-ish
    onBackground: Colors.white,
    surface: Color(0xFF2A2433),
    onSurface: Colors.white,
    tertiary: Color(0xFF2E2A36),
    shadow: Color(0x55222222),
  ),
  scaffoldBackgroundColor: Color(0xFF1B1226),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF2E2A36),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  cardColor: Color(0xFF2A2433),
);
