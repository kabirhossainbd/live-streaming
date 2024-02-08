import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/signal_controller.dart';
import 'package:live_streaming/model/repo/auth_repo.dart';
import 'package:path_provider/path_provider.dart';

class AuthController extends GetxController  implements GetxService {
  final AuthRepo authRepo;
  final SignalRController signalController;
  AuthController({required this.authRepo, required this.signalController});




}
