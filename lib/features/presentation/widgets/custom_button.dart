import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/fonts.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/theme_controller.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (themeController) {
        final buttonColor = backgroundColor ?? themeController.primaryColor;
        final buttonTextColor = textColor ?? Colors.white;

        return SizedBox(
          width: width ?? double.infinity,
          height: height ?? 50,
          child:
              isOutlined
                  ? OutlinedButton.icon(
                    onPressed: isLoading ? null : onPressed,
                    icon:
                        isLoading
                            ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  buttonColor,
                                ),
                              ),
                            )
                            : (icon != null
                                ? Icon(icon, size: 18)
                                : SizedBox.shrink()),
                    label: Text(text),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: buttonColor,
                      side: BorderSide(color: buttonColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          XSizes.borderRadiusLg,
                        ),
                      ),
                      textStyle: TextStyle(
                        fontFamily: XFonts.poppins,
                        fontSize: XSizes.textSizeMd,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  : ElevatedButton.icon(
                    onPressed: isLoading ? null : onPressed,
                    icon:
                        isLoading
                            ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  buttonTextColor,
                                ),
                              ),
                            )
                            : (icon != null
                                ? Icon(icon, size: 18)
                                : SizedBox.shrink()),
                    label: Text(text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      foregroundColor: buttonTextColor,
                      elevation: 2,
                      shadowColor: buttonColor.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          XSizes.borderRadiusLg,
                        ),
                      ),
                      textStyle: TextStyle(
                        fontFamily: XFonts.poppins,
                        fontSize: XSizes.textSizeMd,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
        );
      },
    );
  }
}
