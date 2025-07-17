import 'package:get/get.dart';
import '../views/onboarding_screen.dart';
import '../views/home_screen.dart';
import '../views/splash_screen.dart';

class XRoutes {
  XRoutes._();
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: onboarding, page: () => OnboardingScreen()),
    GetPage(name: home, page: () => HomeScreen()),
  ];
}
