import 'package:flutter/material.dart';
import 'package:live_streaming/src/utils/constants/m_colors.dart';
import 'package:live_streaming/src/utils/constants/m_styles.dart';


ThemeData dark = ThemeData(
    fontFamily: 'Roboto',
    primaryColor: MyColor.colorPrimary,
    primaryColorLight: MyColor.colorPrimary,
    primaryColorDark: MyColor.colorPrimary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: MyColor.colorWhite,
    hintColor: MyColor.colorWhite,
    focusColor: MyColor.getGreyColor(),
    useMaterial3: false,
    /// for text color
    canvasColor: MyColor.colorWhite,
    /// for bg
    highlightColor: MyColor.colorBlack,
    buttonTheme:  const ButtonThemeData(
      buttonColor: MyColor.colorPrimary,
    ),
    cardColor: MyColor.getBackgroundColor(),
    appBarTheme: AppBarTheme(
        backgroundColor: MyColor.colorWhite,
        elevation: 0,
        titleTextStyle: robotoRegular.copyWith(color: MyColor.colorWhite),
        iconTheme:  const IconThemeData(
            size: 20,
            color: MyColor.colorWhite
        )
    ),
    textSelectionTheme:  TextSelectionThemeData(selectionHandleColor:  MyColor.getPrimaryColor(), cursorColor: MyColor.colorPrimary,selectionColor: Colors.transparent),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: MyColor.colorPrimary,
      refreshBackgroundColor: MyColor.colorBlack,
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(MyColor.colorWhite),
      fillColor: MaterialStateProperty.all(MyColor.colorWhite),
      overlayColor: MaterialStateProperty.all(MyColor.colorPrimary),
    ));