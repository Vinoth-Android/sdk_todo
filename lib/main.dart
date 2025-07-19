import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdk_todo/features/data/source/hive_service.dart';
import 'package:sdk_todo/utils/constants/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/presentation/bindings/initial_bindings.dart';
import 'features/presentation/routes/routes.dart';
import 'utils/constants/strings.dart';

/// Entry point of the SDK Todo application
/// Sets up database and preferences before launching the app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive database for local todo storage
    final hiveService = HiveService();
    await hiveService.init();

    // Set up SharedPreferences for app settings and user preferences
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put(sharedPreferences);
  } catch (e) {
    debugPrint('Error during initialization: $e');
  }

  runApp(const MyApp());
}

/// Main application widget that configures the app structure and theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: XFonts.poppins),
      title: XString.appName, // Uses 'SDK Todo' from constants
      getPages: XRoutes.routes, // All app routes defined here
      initialRoute: XRoutes.splash, // Start with splash screen
      initialBinding: InitialBindings(), // Initialize controllers
    );
  }
}
