import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:get/get.dart';
import 'package:index/utils/theming.dart';

import 'package:index/views/pages/front-page.dart';

void main() {
  runApp(IndexApp());
}

/// Sets up the highest quality possible display mode for the app
/// Might become a setting later on, I just really want that 120hz
/// smoothnes...
Future<void> initDisplayMode() async {
  try {
    // Get all modes, and then choose the highest resolution &
    // the highest refresh rate mode
    var modes = await FlutterDisplayMode.supported;
    modes.sort((a, b) => b.height.compareTo(a.height));
    modes.sort((a, b) => b.refreshRate.compareTo(a.refreshRate));
    return await FlutterDisplayMode.setMode(modes[0]);
  } catch (e) {
    print(e);
  }
}

Future<void> initNavigationColors() async {
  // Change the navigation element colors
  Color navigationElementsColor = Get.isDarkMode ? Colors.black : Colors.white;
  await FlutterStatusbarcolor.setStatusBarColor(navigationElementsColor, animate: true);
  await FlutterStatusbarcolor.setNavigationBarColor(navigationElementsColor, animate: true);

  // Check if we need to change the foreground color
  if (useWhiteForeground(navigationElementsColor)) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
  } else {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(false);
  }
}

/// Entrypoint widget for the app. Configures
/// global app theme and loads the first page.
class IndexApp extends StatefulWidget {
  @override
  _IndexAppState createState() => _IndexAppState();
}

class _IndexAppState extends State<IndexApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initDisplayMode();
    initNavigationColors();
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      initNavigationColors();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: Theming.lightTheme(),
        darkTheme: Theming.darkTheme(),
        themeMode: Theming.getAppThemeMode(),
        debugShowCheckedModeBanner: false,
        home: FrontPage());
  }
}
