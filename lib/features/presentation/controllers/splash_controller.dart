import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() async {
    // Show splash screen for at least 3 seconds for better UX
    await Future.delayed(const Duration(seconds: 3));

    try {
      // Check if onboarding has been completed
      final prefs = Get.find<SharedPreferences>();
      final isOnboardingDone = prefs.getBool('onboarding_completed') ?? false;

      if (isOnboardingDone) {
        // Go directly to home if onboarding is completed
        Get.offNamed(XRoutes.home);
      } else {
        // Show onboarding for first-time users
        Get.offNamed(XRoutes.onboarding);
      }
    } catch (e) {
      // If there's an error, default to onboarding
      debugPrint('Error in splash initialization: $e');
      Get.offNamed(XRoutes.onboarding);
    }
  }
}
