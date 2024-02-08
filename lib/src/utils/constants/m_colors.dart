import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/theme_controller.dart';

class MyColor {

  static Color getPrimaryColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFFD20F34) : const Color(0xFFF33358);
  }

  static Color getSecondaryColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFFF9E9EC) : const Color(0xFFF9E9EC);
  }


  static Color getDisableColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF98A2B3).withOpacity(0.5) : const Color(0xFF98A2B3);
  }

  static Color getDisableBgColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFFEAECF0).withOpacity(0.5) : const Color(0xFFEAECF0);
  }

  static Color getBackgroundColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  }

  static Color getGreyColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF6f7275) : const Color(0xFF98A2B3);
  }

  static Color getLightGreyColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF6f7275) : const Color(0xFFF8F9FC);
  }

  static Color getHeaderTextColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFFFFFFFF) : const Color(0xFF342E2E);
  }


  static Color getSubTextColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFFFFFFFF) : const Color(0xFF344054);
  }

  static Color getLightPurpleColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFFFFFFFF) : const Color(0xFFFFEFFB);
  }


  static Color getLightBlueColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFFFFFFFF) : const Color(0xFFDBEBFF);
  }


  static Color getSectionColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFFFFFFFF) : const Color(0xFFEAECF0);
  }

  static Color getBorderColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF525257) : const Color(0xFFE9E9E9);
  }

  static Color getBottomSheetColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF25282B) : const Color(0xFFE9E9E9);
  }

  static Color getHintColor() {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF98a1ab) : const Color(0xFF52575C);
  }


  static Color getButtonBgColor(){
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF2C2C2E) : const Color(0xFFF2F4F7);
  }

  static Color getShadow(){
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF6f7275).withOpacity(0.7) :  Colors.grey[200]!;
  }



  static const Color colorPrimary = Color(0xFFF33358);
  static  Color colorSecondary = const Color(0xFFF9E9EC);
  static const Color colorBlack = Color(0xFF000000);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorGreen = Color(0xFF2AAE48);
  static const Color colorRed = Color(0xFFFC455A);
  static const Color colorYellow = Color(0xFFFACC15);
  static const Color colorBoost = Color(0xFFEAAA08);
  static const Color colorLowYellow = Color(0xFFFCEFC0);
  static const Color colorIndigo = Color(0xFF3538CD);
  static const Color colorLowPrimaryBg = Color(0xFFF9E9EC);
  static const Color colorRedShadow = Color(0xFFF9E9EC);


  static const Map<int, Color> colorMap = {
    50: Color(0x10192D6B),
    100: Color(0x20192D6B),
    200: Color(0x30192D6B),
    300: Color(0x40192D6B),
    400: Color(0x50192D6B),
    500: Color(0x60192D6B),
    600: Color(0x70192D6B),
    700: Color(0x80192D6B),
    800: Color(0x90192D6B),
    900: Color(0xff192D6B),
  };
}
