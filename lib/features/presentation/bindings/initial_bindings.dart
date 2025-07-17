import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/splash_controller.dart';
import '../controllers/theme_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() async {
    Get.put(XThemeController(), permanent: true);
    Get.put(await SharedPreferences.getInstance(), permanent: true);
    Get.put(SplashController(), permanent: true);
  }
}
