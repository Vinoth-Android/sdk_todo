import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/fonts.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/theme_controller.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final bool isRequired;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.isRequired = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<XThemeController>(
      builder: (themeController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label
            RichText(
              text: TextSpan(
                text: label,
                style: TextStyle(
                  fontFamily: XFonts.poppins,
                  fontSize: XSizes.textSizeMd,
                  fontWeight: FontWeight.w600,
                  color: themeController.textColor,
                ),
                children:
                    isRequired
                        ? [
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ]
                        : null,
              ),
            ),
            SizedBox(height: XSizes.spacingSm),

            // Text Field
            TextFormField(
              controller: controller,
              maxLines: maxLines,
              keyboardType: keyboardType,
              validator: validator,
              readOnly: readOnly,
              onTap: onTap,
              style: TextStyle(
                fontFamily: XFonts.poppins,
                fontSize: XSizes.textSizeMd,
                color: themeController.textColor,
              ),
              decoration: InputDecoration(
                hintText: hint ?? 'Enter $label',
                hintStyle: TextStyle(
                  fontFamily: XFonts.poppins,
                  fontSize: XSizes.textSizeMd,
                  color: themeController.textColor.withValues(alpha: 0.5),
                ),
                prefixIcon: prefixIcon,
                suffixIcon: suffixIcon,
                filled: true,
                fillColor:
                    themeController.isLightTheme
                        ? Colors.grey[50]
                        : Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
                  borderSide: BorderSide(
                    color: Colors.grey.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
                  borderSide: BorderSide(
                    color: themeController.primaryColor,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
                  borderSide: BorderSide(color: Colors.red, width: 1),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(XSizes.borderRadiusLg),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: XSizes.paddingMd,
                  vertical: maxLines > 1 ? XSizes.paddingMd : XSizes.paddingSm,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
