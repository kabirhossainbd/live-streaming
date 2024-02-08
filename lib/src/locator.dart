import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/auth_controller.dart';
import 'package:live_streaming/controller/home_controller.dart';
import 'package:live_streaming/controller/language_controller.dart';
import 'package:live_streaming/controller/localization_controller.dart';
import 'package:live_streaming/controller/pk_controller.dart';
import 'package:live_streaming/controller/splash_controller.dart';
import 'package:live_streaming/controller/theme_controller.dart';
import 'package:live_streaming/model/repo/auth_repo.dart';
import 'package:live_streaming/model/repo/home_repo.dart';
import 'package:live_streaming/model/repo/splash_repo.dart';
import 'package:live_streaming/src/data/datasource/remote/http_client.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/ion_controller.dart';
import '../controller/meeting_controller.dart';
import '../controller/signal_controller.dart';
import '../controller/streaming_controller.dart';
import '../model/repo/signal_repo.dart';
import '../model/repo/stream_repo.dart';
import '../model/response/language_model.dart';


Future<Map<String, Map<String, String>>> init() async {

  /// Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: MyKey.baseUrl,  sharedPreferences: Get.find()));


  /// Request
  Get.lazyPut(() => SplashRepo(apiSource: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => HomeRepo(apiSource: Get.find()));
  Get.lazyPut(() => SignalRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => AuthRepo(apiSource: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => StreamRepo(apiClient: Get.find()));


  /// Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => HomeController(homeRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find(), signalController: Get.find()));
  Get.lazyPut(() => SignalRController(signalRepo: Get.find()));
  Get.lazyPut(() => IonController());
  Get.lazyPut(() => MeetingController());
  Get.lazyPut(() => PKController(streamRepo: Get.find()));
  Get.lazyPut(() => StreamingController(streamRepo: Get.find()));
  Get.lazyPut(() => LanguageController(sharedPreferences: Get.find()));

  /// read from json file
  Map<String, Map<String, String>> langFiles = {};
  for(LanguageModel languageModel in MyKey.languages) {
    String jsonToString =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonToString);
    Map<String, String> convertToJson = {};
    mappedJson.forEach((key, value) {
      convertToJson[key] = value.toString();
    });
    langFiles['${languageModel.languageCode}_${languageModel.countryCode}'] = convertToJson;
  }
  return langFiles;
}

