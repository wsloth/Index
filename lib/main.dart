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
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Theming.lightTheme(),
      darkTheme: Theming.darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: FrontPage(),
    );
  }
}
