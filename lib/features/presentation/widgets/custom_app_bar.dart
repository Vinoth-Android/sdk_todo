import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/fonts.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/theme_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (themeController) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                themeController.primaryColor,
                themeController.primaryColor.withValues(alpha: 0.9),
              ],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading:
                showBackButton
                    ? IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: onBackPressed ?? () => Get.back(),
                    )
                    : null,
            title: Text(
              title,
              style: TextStyle(
                fontFamily: XFonts.poppins,
                fontSize: XSizes.textSizeLg,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            actions: actions,
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
