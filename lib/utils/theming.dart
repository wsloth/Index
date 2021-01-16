import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Theming {
  /// Check if we are running in dark or light mode
  static bool isDarkMode(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return mode.brightness == Brightness.dark;
  }

  static ThemeMode getAppThemeMode() {
    // return ThemeMode.dark;
    // return ThemeMode.light;
    return ThemeMode.system;
  }

  static ThemeData lightTheme() {
    return ThemeData(
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        subtitle2: TextStyle(
          color: Color.fromRGBO(150, 150, 150, 1),
        ),
        headline1: GoogleFonts.vidaloka(
          color: Colors.black,
          textStyle: TextStyle(fontSize: 56.0),
        ),
        headline2: GoogleFonts.vidaloka(
          color: Color.fromRGBO(75, 75, 75, 1),
          textStyle: TextStyle(fontSize: 20),
        ),
        headline3: GoogleFonts.vidaloka(
          textStyle: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 25,
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(75, 75, 75, 1),
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      primarySwatch: Colors.grey,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      // TYPOGRAPHY
      textTheme: TextTheme(
        subtitle2: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
        headline1: GoogleFonts.vidaloka(
          color: Colors.white,
          textStyle: TextStyle(fontSize: 56.0),
        ),
        headline2: GoogleFonts.vidaloka(
          color: Color.fromRGBO(222, 222, 222, 1),
          textStyle: TextStyle(fontSize: 20),
        ),
        headline3: GoogleFonts.vidaloka(
          textStyle: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 25,
            fontWeight: FontWeight.normal,
            color: Color.fromRGBO(222, 222, 222, 1),
          ),
        ),
      ),
    );
  }
}
