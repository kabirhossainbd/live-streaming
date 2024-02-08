import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

Future<bool> isNetworkStable() async {
  final ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    return false; /// No network connection
  } else if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty && response.first.rawAddress.isNotEmpty) {
        return true; /// Network connection is stable
      }
    } on PlatformException catch (e) {
      print('Error: $e');
      return false; /// Network connection is unstable
    }
  }
  return false; /// Default to network being unstable
}


