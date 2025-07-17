import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdk_todo/utils/constants/fonts.dart';

import 'features/presentation/bindings/initial_bindings.dart';
import 'features/presentation/routes/routes.dart';
import 'utils/constants/strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, fontFamily: XFonts.poppins),
      title: XString.appName,
      getPages: XRoutes.routes,
      initialRoute: XRoutes.splash,
      initialBinding: InitialBindings(),
    );
  }
}
