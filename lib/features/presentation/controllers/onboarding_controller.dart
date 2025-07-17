import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/routes.dart';

class OnboardingController extends GetxController {
  void continueToHome() {
    final prefs = Get.find<SharedPreferences>();
    prefs
        .setBool('onbording', true)
        .then((value) => Get.offNamed(XRoutes.home));
  }
}
