import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/fonts.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/splash_controller.dart';
import '../controllers/theme_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (themeController) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  themeController.primaryColor,
                  themeController.primaryColor.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Icon/Logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.task_alt_rounded,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: XSizes.spacingXl),

                    // App Name
                    Text(
                      'SDK Todo',
                      style: TextStyle(
                        fontFamily: XFonts.poppins,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),

                    SizedBox(height: XSizes.spacingSm),

                    // Subtitle
                    Text(
                      'Field Work Task Manager',
                      style: TextStyle(
                        fontFamily: XFonts.poppins,
                        fontSize: XSizes.textSizeMd,
                        fontWeight: FontWeight.w300,
                        color: Colors.white.withValues(alpha: 0.9),
                        letterSpacing: 0.5,
                      ),
                    ),

                    SizedBox(height: XSizes.spacingXl * 2),

                    // Loading Indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    ),

                    SizedBox(height: XSizes.spacingLg),

                    // Loading Text
                    Text(
                      'Loading...',
                      style: TextStyle(
                        fontFamily: XFonts.poppins,
                        fontSize: XSizes.textSizeSm,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
