import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:get/get.dart';
import 'package:index/utils/theming.dart';

import 'package:index/views/pages/front-page.dart';

void main() {
  putLumberdashToWork(withClients: [ColorizeLumberdash()]);
  runApp(IndexApp());
}

/// Sets up the highest quality possible display mode for the app
/// Might become a setting later on, I just really want that 120hz
/// smoothnes...
Future<void> initDisplayMode() async {
  try {
    return await FlutterDisplayMode.setHighRefreshRate();
  } catch (e) {
    print(e);
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

    // Not the most beautiful solution, but the theme context
    // is not available yet during this lifecycle hook, so we
    // can wait a tiny bit and set the right colors afterwards.
    new Future.delayed(const Duration(milliseconds: 100), () {
      Theming.alignNavigationElementThemeWithSystemBrightness();
    });
  }

  @override
  void didChangePlatformBrightness() {
    // Change theme and force it to use dark
    Theming.alignNavigationElementThemeWithSystemBrightness(
        overrideToColor: Get.isDarkMode ? Colors.white : Colors.black);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Theming.alignNavigationElementThemeWithSystemBrightness();
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
      home: FrontPage(),
    );
  }
}
