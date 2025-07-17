import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/sizes.dart';
import '../controllers/theme_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (themeController) {
        return Scaffold(
          backgroundColor: themeController.backgroundColor,
          appBar: AppBar(
            backgroundColor: themeController.backgroundColor,
            title: Text('change_language'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'hello',
                  style: TextStyle(color: themeController.textColor),
                ),
                SizedBox(height: XSizes.spacingMd),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeController.primaryColor,
                  ),
                  onPressed: () {
                    themeController.changeTheme(!themeController.isLightTheme);
                  },
                  child: Text(
                    'Change Theme',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
