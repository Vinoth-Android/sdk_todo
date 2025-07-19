import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/fonts.dart';
import '../../../utils/constants/images.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/onboarding_controller.dart';
import '../controllers/theme_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final OnboardingController controller = Get.put(OnboardingController());
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (XThemeController themeController) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFF5F5F7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: XSizes.paddingXl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Spacer to push content to center
                        const Spacer(flex: 1),

                        // Image with subtle shadow
                        Container(
                          width: XSizes.onboardingImageSize * 0.8,
                          height: XSizes.onboardingImageSize * 0.8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(XSizes.paddingLg),
                          child: Image.asset(
                            XImages.onBoarding,
                            fit: BoxFit.contain,
                          ),
                        ),

                        SizedBox(height: XSizes.spacingXl * 1.5),

                        // Title with custom font
                        Text(
                          'Task Management',
                          style: TextStyle(
                            fontFamily: XFonts.poppins,
                            color: XColors.textColor,
                            fontSize: XSizes.textSize3xl,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),

                        SizedBox(height: XSizes.spacingSm),

                        // Subtitle with minimal design
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: XSizes.paddingSm,
                            vertical: XSizes.paddingXs,
                          ),
                          decoration: BoxDecoration(
                            color: XColors.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              XSizes.borderRadiusLg,
                            ),
                          ),
                          child: Text(
                            'Simplify Your Day',
                            style: TextStyle(
                              fontFamily: XFonts.poppins,
                              color: XColors.primaryColor,
                              fontSize: XSizes.textSizeMd,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: XSizes.spacingLg),

                        // Description with better readability
                        Text(
                          'Manage your tasks efficiently and stay organized with our minimal and intuitive interface.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: XFonts.poppins,
                            color: Color.fromRGBO(
                              XColors.textColor.red,
                              XColors.textColor.green,
                              XColors.textColor.blue,
                              0.7,
                            ),
                            fontSize: XSizes.textSizeMd,
                            height: 1.6,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        // Spacer to push button to bottom
                        const Spacer(flex: 1),

                        // Get Started button with minimal design
                        GestureDetector(
                          onTap: () => controller.continueToHome(),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: XSizes.paddingLg,
                            ),
                            decoration: BoxDecoration(
                              color: XColors.primaryColor,
                              borderRadius: BorderRadius.circular(
                                XSizes.borderRadiusLg,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: XColors.primaryColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontFamily: XFonts.poppins,
                                    color: Colors.white,
                                    fontSize: XSizes.textSizeLg,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: XSizes.spacingSm),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: XSizes.spacingXl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
