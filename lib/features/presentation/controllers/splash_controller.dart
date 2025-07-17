import 'package:get/get.dart';

import '../routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // final prefs = Get.find<SharedPreferences>();
    // final isOnBoardingDone = prefs.getBool('onbording') ?? false;
    // Future.delayed(const Duration(seconds: 2), () {
    //   if (isOnBoardingDone) {
    //     Get.offNamed(XRoutes.home);
    //   } else {
    //     Get.offNamed(XRoutes.onboarding);
    //   }
    // });

    Future.delayed(const Duration(seconds: 2), () {
      Get.offNamed(XRoutes.onboarding);
    });
  }
}
