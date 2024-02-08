import 'dart:convert';

import 'package:get/get.dart';
import 'package:live_streaming/src/data/datasource/remote/http_client.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthRepo {
  final ApiClient apiSource;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiSource, required this.sharedPreferences});


  Future<Response> login({required String studentId, required String name}) async {
    return await apiSource.postData(MyKey.loginUri,
        {
          "student_id": studentId,
          "name": name
        });
  }

  Future<bool> saveUserToken(String token) async {
    apiSource.token = token;
    apiSource.updateHeader(token);
    return await sharedPreferences.setString(MyKey.token, token);
  }


  String getUserToken() {
    return sharedPreferences.getString(MyKey.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(MyKey.token);
  }


  void saveUserId(int id) {
    sharedPreferences.setInt(MyKey.userId, id);
  }

  int getUserId() {
    var id = sharedPreferences.getInt(MyKey.userId);
    if (id != null) {
      return id;
    } else {
      return 0;
    }
  }

  void saveFullName(String name) {
    sharedPreferences.setString(MyKey.userName, name);
  }

  String getFullName() {
    return sharedPreferences.getString(MyKey.userName) ?? '';
  }

  Future<bool> clearSharedData() async {
    sharedPreferences.remove(MyKey.token);
    sharedPreferences.remove(MyKey.userId);
    sharedPreferences.remove(MyKey.userName);
    return true;
  }
}