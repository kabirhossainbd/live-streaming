import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Dimensions {
  final width = MediaQuery.of(Get.context!).size.width;
  static double height = MediaQuery.of(Get.context!).size.height;


  /// for font size
  static  double fontSizeOverExtraSmall = 10.0.sp;
  static  double fontSizeExtraSmall = 12.0.sp;
  static  double fontSizeSmall = 14.0.sp;
  static  double fontSizeDefault = 16.0.sp;
  static  double fontSizeLarge = 18.0.sp;
  static  double fontSizeExtraLarge = 20.0.sp;
  static  double fontSizeOverLarge = 24.0.sp;
  static const double smallSizeFont = 11.0;
  static const double mediumSmallSizeFont = 13.0;
  static const double bigSizeFont = 30.0;
  static double fontSize40 = height / 16;



  /// for padding/margin
  static const double paddingSizeExtraSmall = 5.0;
  static const double paddingSizeMediumSmall = 8.0;
  static const double paddingSizeSmall = 10.0;
  static const double paddingSizeDefault = 16.0;
  static const double paddingSizeLarge = 18.0;
  static const double paddingSizeMiniLarge = 20.0;
  static const double paddingSizeExtraLarge = 25.0;
}
