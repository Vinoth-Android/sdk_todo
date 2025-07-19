import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/fonts.dart';
import '../constants/sizes.dart';

/// Helper class for displaying consistent snackbar notifications
/// Provides success, error, warning, and info message types
class SnackbarHelper {
  static void showSuccess(String message) {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: XSizes.iconSizeSm,
              ),
              SizedBox(width: XSizes.spacingXs),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: XFonts.poppins,
                    fontSize: XSizes.textSizeXs,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 800),
          behavior: SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(XSizes.borderRadiusSm),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: XSizes.paddingSm,
            vertical: XSizes.paddingMd,
          ),
        ),
      );
    }
  }

  static void showError(String message) {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_rounded,
                color: Colors.white,
                size: XSizes.iconSizeSm,
              ),
              SizedBox(width: XSizes.spacingXs),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: XFonts.poppins,
                    fontSize: XSizes.textSizeXs,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 800),
          behavior: SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(XSizes.borderRadiusSm),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: XSizes.paddingSm,
            vertical: XSizes.paddingMd,
          ),
        ),
      );
    }
  }

  static void showWarning(String message) {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.white,
                size: XSizes.iconSizeSm,
              ),
              SizedBox(width: XSizes.spacingXs),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: XFonts.poppins,
                    fontSize: XSizes.textSizeXs,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
          duration: Duration(milliseconds: 800),
          behavior: SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(XSizes.borderRadiusSm),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: XSizes.paddingSm,
            vertical: XSizes.paddingMd,
          ),
        ),
      );
    }
  }

  static void showInfo(String message) {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_rounded,
                color: Colors.white,
                size: XSizes.iconSizeSm,
              ),
              SizedBox(width: XSizes.spacingXs),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    fontFamily: XFonts.poppins,
                    fontSize: XSizes.textSizeXs,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          duration: Duration(milliseconds: 800),
          behavior: SnackBarBehavior.fixed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(XSizes.borderRadiusSm),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: XSizes.paddingSm,
            vertical: XSizes.paddingMd,
          ),
        ),
      );
    }
  }
}