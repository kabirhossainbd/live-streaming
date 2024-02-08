import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/model/repo/home_repo.dart';
import 'package:live_streaming/model/response/story_model.dart';

class HomeController extends GetxController  implements GetxService {
  final HomeRepo homeRepo;
  HomeController({required this.homeRepo});


  List<StoryModel> _storyList = [];
  List<StoryModel> get storyList => _storyList;

  Future<void> getStoryList() async {
    Response response = await homeRepo.getStoryList();
    if (response.statusCode == 200) {
      _storyList = [];
      _storyList.addAll(response.body);
      update();
    } else {
      debugPrint(response.toString());
    }
  }

}
