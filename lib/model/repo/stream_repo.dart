
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:live_streaming/model/response/body/room_body.dart';
import 'package:live_streaming/src/utils/constants/m_key.dart';
import '../../src/data/datasource/remote/http_client.dart';

class StreamRepo extends GetxController  implements GetxService{
  final ApiClient apiClient;
  StreamRepo({required this.apiClient});

  Future<http.StreamedResponse> liveRoomBody(LiveRoomBody liveRoomBody, File? file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${MyKey.baseUrl}${MyKey.createRoomUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      request.files.add(http.MultipartFile('picture', file.readAsBytes().asStream(), file.lengthSync(), filename: file.path.split('/').last));
    }
    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'title': liveRoomBody.title ?? '',
      'seat_type': liveRoomBody.seatType ?? '',
      'status' : liveRoomBody.status ?? '',
      'server_id' : '0',
      'tags' : liveRoomBody.tags.toString().replaceAll('[', '').replaceAll(']', ''),
      'price' : '500',
      'category_id' : liveRoomBody.categoryId.toString(),
    });
    request.fields.addAll(fields);
    debugPrint('---------->>>>> REPO $fields');
    http.StreamedResponse response = await request.send();
    return response;
  }


}