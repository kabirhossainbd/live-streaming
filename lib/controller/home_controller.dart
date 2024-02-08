import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_streaming/model/repo/home_repo.dart';
import 'package:live_streaming/model/response/room_list.dart';
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



  int _offset = 1;
  int get offset => _offset;
  List<String> _offsetList = [];
  bool _isPageLoader = false;
  bool get isPageLoader => _isPageLoader;

  void setOffset(int offset) {
    _offset = offset;
  }


  List<Data> _roomList = [];
  List<Data> get roomList => _roomList;

  int _roomTotalSize = 0;
  int get roomTotalSize => _roomTotalSize;

  bool _emptyRoomList = true;
  bool get emptyRoomList => _emptyRoomList;

  Future<void> getRoomList(String offset, bool reload, bool notify) async {
    if (offset == '1' || reload) {
      _offsetList = [];
      _offset = 1;
      if (reload) {
        _roomList = [];
      }
      if (notify) {
        update();
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await homeRepo.getRoomList(offset);
      if (response.statusCode == 200) {
        if (offset == '1') {
          _roomList = [];
        }
        _roomList.addAll(RoomModel.fromJson(response.body).data!);
        _roomTotalSize = RoomModel.fromJson(response.body).total!;
        _isPageLoader = false;
        _emptyRoomList = false;
        update();
      } else {
        debugPrint(response.toString());
      }
    } else {
      if (isPageLoader) {
        _isPageLoader = false;
        update();
      }
    }
  }
  void showBottomLoader(){
    _isPageLoader = true;
    update();
  }



}
