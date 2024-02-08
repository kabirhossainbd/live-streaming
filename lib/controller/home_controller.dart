import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/model/repo/home_repo.dart';

class HomeController extends GetxController  implements GetxService {
  final HomeRepo homeRepo;
  HomeController({required this.homeRepo});

}
