import 'package:flutter/material.dart';

class Theming {
  /// Check if we are running in dark or light mode
  static bool isDarkMode(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return mode.brightness == Brightness.dark;
  }
}
