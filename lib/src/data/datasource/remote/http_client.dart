import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:live_streaming/controller/auth_controller.dart';
import 'package:live_streaming/services/network_extension.dart';
import 'package:live_streaming/src/data/datasource/remote/exception.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static const String noInternetMessage = 'Connection lost due to internet connection';
  final int timeoutInSeconds = 30;
  static const String noResponse = 'Request Timeout';

  String? token;
  Map<String, String>? _mainHeaders;

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(MyKey.token);
    if(foundation.kDebugMode) {
      debugPrint('Token: $token');
    }
    updateHeader(token);
  }

  void updateHeader(String? token) {
    Map<String, String> header = {};
    header.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    });
    _mainHeaders = header;
  }

  Future<Response> getData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      if(foundation.kDebugMode) {
        debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      http.Response remoteResponse = await http.get(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(remoteResponse, uri);
    } catch (e) {
      debugPrint('------------${e.toString()}');
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String>? headers, int? timeout}) async {

    if(await isNetworkStable()){
      try {
        if(foundation.kDebugMode) {
          debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
          debugPrint('====> API Body: $body');
        }
        http.Response response = await http.post(Uri.parse(appBaseUrl+uri), body: jsonEncode(body), headers: headers ?? _mainHeaders,).timeout(Duration(seconds: timeout ?? timeoutInSeconds));
        return handleResponse(response, uri);
      } catch (e) {
        return handleResponse(http.Response('', 405), noResponse);
        //return const Response(statusCode: 401, statusText: noResponse);
      }
    }else{
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body, {Map<String, String>? headers}) async {
    try {
      if(foundation.kDebugMode) {
        debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
        debugPrint('====> API Body: $body');
      }
      http.Response remoteResponse = await http.put(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(remoteResponse, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri, {Map<String, String>? headers}) async {
    try {
      if(foundation.kDebugMode) {
        debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      }
      http.Response remoteResponse = await http.delete(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(remoteResponse, uri);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }


/*

  Timer? _timer;
  Response handleResponse(http.Response response, String uri) {
    Response responseBody;
    if(response.body.isNotEmpty){
      responseBody = Response(
        body: jsonDecode(response.body),
        bodyString: response.body.toString(),
        request: Request(headers: response.request!.headers, method: response.request!.method, url: response.request!.url),
        headers: response.headers,
        statusCode: response.statusCode,
        statusText: response.reasonPhrase,
      );
    }else{
      responseBody = Response(
        body: null,
        statusCode: response.statusCode,
      );
    }
    /// session expire
    if(responseBody.statusCode == 401){
      if(Get.find<AuthController>().isSessionExpire) {
        Get.find<AuthController>().setSessionExpire(false, true);
        Get.dialog(SessionExpiredDialog(timer: _timer,)).then((value){
          if(value.toString().contains('done')){
            _timer == null;
            _timer?.cancel();
          }
        });
        if (_timer != null) {
          _timer?.cancel();
        }
        _timer = Timer(const Duration(seconds: 5), _logOutUser);
      }
    } else if(responseBody.statusCode != 200 && responseBody.body != null && responseBody.body is !String) {
      if(responseBody.body.toString().startsWith('{errors: [{code:')) {
        ErrorClass _errorResponse = ErrorClass.fromJson(responseBody.body);
        responseBody = Response(statusCode: responseBody.statusCode, body: responseBody.body, statusText: _errorResponse.errors![0].message);
      }else if(responseBody.body.toString().startsWith('message')) {
        responseBody = Response(statusCode: responseBody.statusCode, body: responseBody.body, statusText: responseBody.body['message']);
      }
    }else if(responseBody.statusCode != 200 && responseBody.body == null) {
      responseBody = const Response(statusCode: 1005, statusText: noInternetMessage);
    }
    if(foundation.kDebugMode) {
      debugPrint('====> API Response: [${responseBody.statusCode}] $uri\n${responseBody.body}');
    }
    return responseBody;
  }

  void _logOutUser() {
    _timer = null;
    _timer?.cancel();
    Get.find<AuthController>().clearSharedData().then((condition) {
      // Get.find<AuthController>().logOut();
      Get.find<SignalRController>().logout();
      Get.off(const LoginScreen());
    });
  }
*/



  Response handleResponse(http.Response response, String uri) {
    dynamic dataBody;
    try {
      dataBody = jsonDecode(response.body);
    }catch(e) {
      rethrow;
    }
    Response remoteResponse = Response(
      body: dataBody ?? response.body, bodyString: response.body.toString(),
      request: Request(headers: response.request!.headers, method: response.request!.method, url: response.request!.url),
      headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase,
    );
    if(remoteResponse.statusCode != 200 && remoteResponse.body != null && remoteResponse.body is !String) {
      if(remoteResponse.body.toString().startsWith('{errors: [{code:')) {
        ErrorClass errorResponse = ErrorClass.fromJson(remoteResponse.body);
        remoteResponse = Response(statusCode: remoteResponse.statusCode, body: remoteResponse.body, statusText: errorResponse.errors![0].message);
      }else if(remoteResponse.body.toString().startsWith('{message')) {
        remoteResponse = Response(statusCode: remoteResponse.statusCode, body: remoteResponse.body, statusText: remoteResponse.body['message']);
      }
    }else if(remoteResponse.statusCode != 200 && remoteResponse.body == null) {
      remoteResponse = const Response(statusCode: 1005, statusText: noInternetMessage);
    }
    if(foundation.kDebugMode) {
      debugPrint('====> API Response: [${remoteResponse.statusCode}] $uri\n${remoteResponse.body}');
    }
    return remoteResponse;
  }
}
