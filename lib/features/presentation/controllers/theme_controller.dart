import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/fonts.dart';

class XThemeController extends GetxController {
  final RxBool _isLight = false.obs;

  get isLightTheme => _isLight.value;

  // ! Constrains
  double get height => Get.height;
  double get width => Get.width;

  // ! Colors
  Color get primaryColor =>
      _isLight.value ? XColors.primaryColor : XColors.primaryColor;

  Color get backgroundColor =>
      _isLight.value ? XColors.backgroundColor : XColors.backgroundColorDark;

  Color get textColor =>
      _isLight.value ? XColors.textColor : XColors.textColorDark;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isLight.value = prefs.getBool('isLightTheme') ?? false;
    Get.changeTheme(
      _isLight.value
          ? ThemeData.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(
              fontFamily: XFonts.poppins,
            ),
          )
          : ThemeData.dark().copyWith(
            textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: XFonts.poppins,
            ),
          ),
    );
    update();
  }

  void changeTheme(bool isLight) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLightTheme', isLight);
    _isLight.value = isLight;
    Get.changeTheme(
      isLight
          ? ThemeData.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
          )
          : ThemeData.dark().copyWith(
            textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
          ),
    );
    update();
  }
}
