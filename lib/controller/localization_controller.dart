import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController  extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  LocalizationController({required this.sharedPreferences}) {
    _loadCurrentLanguage();
  }

  Locale _locale = const Locale('en', 'US');
  Locale get locale => _locale;
 /* bool _isLtr = true;
  bool get isLtr => _isLtr;*/

  void setLanguage(Locale locale) {
    _locale = locale;
    _saveLanguage(_locale);
    Get.updateLocale(locale);
    update();
  }

  final int _languageIndex = 0;
  int get languageIndex => _languageIndex;

  // void toggleLanguage() {
  //   if(_locale.languageCode == 'en') {
  //     _languageIndex = 0;
  //     _locale = const Locale('ind', 'SA');
  //    // _isLtr = false;
  //   }else {
  //     _languageIndex = 1;
  //     _locale = const Locale('en', 'US');
  //     //_isLtr = true;
  //   }
  //   _saveLanguage(_locale);
  //   Get.updateLocale(locale);
  //   update();
  // }

  _loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(MyKey.languageCode) ?? 'de',
        sharedPreferences.getString(MyKey.countryCode) ?? 'US');
   // _isLtr = _locale.languageCode == 'en';
    update();
  }

  _saveLanguage(Locale locale) async {
    sharedPreferences.setString(MyKey.languageCode, locale.languageCode);
    sharedPreferences.setString(MyKey.countryCode, locale.countryCode!);
  }

}