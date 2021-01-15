import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

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

/// Entrypoint widget for the app. Configures
/// global app theme and loads the first page.
class IndexApp extends StatefulWidget {
  @override
  _IndexAppState createState() => _IndexAppState();
}

class _IndexAppState extends State<IndexApp> {
  @override
  void initState() {
    super.initState();
    initDisplayMode();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: FrontPage());
  }
}
