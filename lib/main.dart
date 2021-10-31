import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:get/get.dart';
import 'package:index/utils/theming.dart';

import 'package:index/views/pages/onboarding_screen.dart';
import 'package:index/views/pages/front-page.dart';
import 'package:path_provider/path_provider.dart';

import 'models/articles-data-hive_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.storage.request().isGranted;
  putLumberdashToWork(withClients: [ColorizeLumberdash()]);

  // Initialise Hive
  final documentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(documentDirectory.path);
  Hive.registerAdapter(ArticlesDataHiveModelAdapter());
  await Hive.openBox<ArticlesDataHiveModel>('articlesData');

  var onboardValue;
  final onboardprefs = await SharedPreferences.getInstance();
  onboardValue = onboardprefs.getInt('onboardState');

  if (onboardValue == 1) {
    runApp(IndexApp());
  } else {
    runApp(OnboardApp());
  }
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

class OnboardApp extends StatefulWidget {
  @override
  _OnboardAppState createState() => _OnboardAppState();
}

class _OnboardAppState extends State<OnboardApp> with WidgetsBindingObserver {
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
      home: OnboardingScreen(),
    );
  }
}
