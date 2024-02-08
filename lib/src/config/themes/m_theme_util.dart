import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';


class ThemeUtil{
  static void makeSplashTheme(){
    SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            statusBarColor: MyColor.colorWhite,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: MyColor.colorWhite,
            systemNavigationBarIconBrightness: Brightness.dark
        )
    );
  }
  static void allScreenTheme(){
    SystemChrome.setSystemUIOverlayStyle(
         const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: MyColor.colorWhite,
            systemNavigationBarIconBrightness: Brightness.dark
        )
    );
  }
}