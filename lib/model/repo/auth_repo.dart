import 'dart:convert';

import 'package:get/get.dart';
import 'package:live_streaming/src/data/datasource/remote/http_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  final ApiClient apiSource;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiSource, required this.sharedPreferences});


}