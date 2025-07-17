import 'package:get/get.dart';

class XSizes {
  XSizes._();

  static final double _baseWidth = Get.width > 600 ? 600.0 : 375.0;
  static double scaleFactor = Get.width / _baseWidth;

  static double get screenPadding => 16.0 * scaleFactor;
  static double get paddingXs => 4.0 * scaleFactor;
  static double get paddingSm => 8.0 * scaleFactor;
  static double get paddingMd => 16.0 * scaleFactor;
  static double get paddingLg => 24.0 * scaleFactor;
  static double get paddingXl => 32.0 * scaleFactor;
  static double get paddingXxl => 48.0 * scaleFactor;

  static double get marginXs => 4.0 * scaleFactor;
  static double get marginSm => 8.0 * scaleFactor;
  static double get marginMd => 16.0 * scaleFactor;
  static double get marginLg => 24.0 * scaleFactor;
  static double get marginXl => 32.0 * scaleFactor;
  static double get marginXxl => 48.0 * scaleFactor;

  static double get borderSizeSm => 1.0 * scaleFactor;
  static double get borderSizeMd => 2.0 * scaleFactor;
  static double get borderSizeLg => 4.0 * scaleFactor;
  static double get borderSizeXl => 8.0 * scaleFactor;

  static double get borderRadiusXs => 2.0 * scaleFactor;
  static double get borderRadiusSm => 4.0 * scaleFactor;
  static double get borderRadiusMd => 8.0 * scaleFactor;
  static double get borderRadiusLg => 16.0 * scaleFactor;
  static double get borderRadiusXl => 24.0 * scaleFactor;
  static double get borderRadiusXxl => 32.0 * scaleFactor;
  static double get borderRadiusCircle => 100.0 * scaleFactor;

  static double get iconSizeSm => 16.0 * scaleFactor;
  static double get iconSizeMd => 24.0 * scaleFactor;
  static double get iconSizeLg => 32.0 * scaleFactor;
  static double get iconSizeXl => 48.0 * scaleFactor;
  static double get iconSizeXxl => 64.0 * scaleFactor;

  static double get textSizeXs => 10.0 * scaleFactor;
  static double get textSizeSm => 12.0 * scaleFactor;
  static double get textSizeMd => 14.0 * scaleFactor;
  static double get textSizeLg => 16.0 * scaleFactor;
  static double get textSizeXl => 18.0 * scaleFactor;
  static double get textSize2xl => 20.0 * scaleFactor;
  static double get textSize3xl => 24.0 * scaleFactor;
  static double get textSize4xl => 28.0 * scaleFactor;

  static double get spacingXs => 4.0 * scaleFactor;
  static double get spacingSm => 8.0 * scaleFactor;
  static double get spacingMd => 16.0 * scaleFactor;
  static double get spacingLg => 24.0 * scaleFactor;
  static double get spacingXl => 32.0 * scaleFactor;
  static double get spacingXxl => 48.0 * scaleFactor;

  static double get onboardingImageSize => 300.0 * scaleFactor;
}
