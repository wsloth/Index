import 'package:flutter/material.dart';
import 'package:index/views/pages/front-page.dart';

void main() {
  runApp(MyApp());
}

/// Entrypoint widget for the app. Configures
/// global app theme and loads the first page.
class MyApp extends StatelessWidget {
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
      home: FrontPage()
    );
  }
}

