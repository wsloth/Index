import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumberdash/lumberdash.dart';

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
      accentColor: Colors.grey,
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

  // // ignore: avoid_init_to_null
  // static Future<void> alignNavigationElementThemeWithSystemBrightness({Color overrideToColor}) async {
  //   // Change the navigation element colors
  //   Color navigationElementsColor = Get.isDarkMode ? Colors.black : Colors.white;
  //   if (overrideToColor != null) {
  //     navigationElementsColor = overrideToColor;
  //   }

  //   logMessage('Changing navigation elements color to ${navigationElementsColor.toString()}');

  //   await FlutterStatusbarcolor.setStatusBarColor(navigationElementsColor,
  //       animate: true);
  //   await FlutterStatusbarcolor.setNavigationBarColor(navigationElementsColor,
  //       animate: true);

  //   // Check if we need to change the foreground color
  //   if (useWhiteForeground(navigationElementsColor)) {
  //     FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  //     FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  //   } else {
  //     FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  //     FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  //   }
  // }
}
