import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/model/response/story_model.dart';
import 'package:live_streaming/src/data/datasource/remote/http_client.dart';
import 'package:live_streaming/src/utils/constants/m_images.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';


class HomeRepo {
  final ApiClient apiSource;
  HomeRepo({required this.apiSource});

  Future<Response> getStoryList() async {
    try {
      final List<StoryModel> storyList = [

        StoryModel(id: 0, profile: MyImage.image1, userName: "Nill Poddho", storyUser: [
          StoryUser(storyType: 'image', media: 'https://d3nn873nee648n.cloudfront.net/HomeImages/Nature.jpg', duration: 3.6, caption: 'This is new Story', time: "12 hours ago", color: Colors.blueGrey),
          StoryUser(storyType: 'text', media: '', duration: 3.6, caption: 'Wow! is new Story', time: "10 hours ago", color: Colors.red),
          StoryUser(storyType: 'image', media: 'https://wallpaperaccess.com/full/4776577.jpg', duration: 2.6, caption: 'Amazing is new Story', time: "Just Now", color: Colors.green),


        ] ),
        StoryModel(id: 1, profile: MyImage.image2, userName: "Nill Akash", storyUser: [StoryUser(storyType: 'text', media: '', duration: 3.6, caption: 'This is new Story, There are few min i wanna go', time: "12 hours ago", color: Colors.pinkAccent)] ),
        StoryModel(id: 2, profile: MyImage.image3, userName: "Kazi Ibrahim", storyUser: [StoryUser(storyType: 'video', media: 'https://raw.githubusercontent.com/blackmann/storyexample/master/assets/small.mp4', duration: 3.6, caption: 'This is new Story', time: "12 hours ago", color: Colors.blueGrey)] ),
      ];
      Response response = Response(body: storyList, statusCode: 200);
      return response;
    } catch (e) {
      return const Response(statusCode: 404, statusText: 'Video not found');
    }
  }


  Future<Response> getRoomList(String offset) async {
    return await apiSource.getData('${MyKey.getRoomUri}?page=$offset');
  }

}
