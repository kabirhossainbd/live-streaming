import 'package:flutter/material.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';

ThemeData light = ThemeData(
    fontFamily: 'Roboto',
    primaryColor: MyColor.colorPrimary,
    primaryColorLight: MyColor.colorPrimary,
    primaryColorDark: MyColor.colorPrimary,
    colorScheme: const ColorScheme.light(brightness: Brightness.light, primary: MyColor.colorPrimary),
    scaffoldBackgroundColor: MyColor.getGreyColor().withOpacity(0.3),
    hintColor: MyColor.colorBlack,
    /// for text color
    canvasColor: MyColor.colorBlack,
    useMaterial3: false,
   /// for bg
    highlightColor: MyColor.colorWhite,
    buttonTheme: const ButtonThemeData(
      buttonColor: MyColor.colorPrimary,
    ),

  textSelectionTheme:  TextSelectionThemeData(selectionHandleColor:  MyColor.getPrimaryColor(), cursorColor: MyColor.colorPrimary,selectionColor: Colors.white),
  cardColor: MyColor.getBackgroundColor(),
    appBarTheme: AppBarTheme(
        backgroundColor: MyColor.colorPrimary,
        elevation: 0,
        titleTextStyle: robotoRegular.copyWith(color: MyColor.colorWhite),
        iconTheme:  const IconThemeData(
            size: 20,
            color: MyColor.colorWhite,
        )
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MyColor.colorPrimary,
      refreshBackgroundColor: MyColor.colorWhite,
    ),


    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(MyColor.colorWhite),
      fillColor: MaterialStateProperty.all(MyColor.colorPrimary),
    ),
);
