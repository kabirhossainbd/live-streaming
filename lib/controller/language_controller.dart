import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/model/response/language_model.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  LanguageController({required this.sharedPreferences}){
    _getSelectIndex();
    _getDeviceLanguage();
  }

  int _selectIndex = 0;
  int get selectIndex => _selectIndex;

  void setSelectIndex(int index) {
    sharedPreferences.setInt(MyKey.languageIndex, index);
    _selectIndex = index;
    update();
  }

  int _selectLan = 0;
  int get selectLan => _selectLan;

  void setSelectLan(int index) {
    _selectLan = index;
    update();
  }
  void _getSelectIndex() async {
    _selectIndex = sharedPreferences.getInt(MyKey.languageIndex) ?? 0;
  }

  bool _deviceLanguage = true;
  bool get deviceLanguage => _deviceLanguage;

  setDeviceLanguage(bool val){
    sharedPreferences.setBool(MyKey.deviceLan, val);
    _deviceLanguage = val;
    update();
  }
  void _getDeviceLanguage() async {
    _deviceLanguage = sharedPreferences.getBool(MyKey.deviceLan) ?? true;
  }




  // final bool  _isLoading = true;
  // bool get isLoading => _isLoading;
  //

  // void searchLanguage(String query, BuildContext context) {
  //   if (query.isEmpty) {
  //     _languages.clear();
  //     _languages = languageRepo.getAllLanguages(context: context);
  //     update();
  //   } else {
  //     _selectIndex = -1;
  //     _languages = [];
  //     languageRepo.getAllLanguages(context: context).forEach((product) async {
  //       if (product.languageName!.toLowerCase().contains(query.toLowerCase())) {
  //         _languages.add(product);
  //       }
  //     });
  //     update();
  //   }
  // }
  //

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  void initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages.clear();
      _languages = MyKey.languages;
    }
  }
}
