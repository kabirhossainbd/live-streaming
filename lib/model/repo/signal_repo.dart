import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/hub_connection.dart';

import '../../src/data/datasource/remote/http_client.dart';

class SignalRepo extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  SignalRepo({required this.sharedPreferences, required this.apiClient});

  void setNick(HubConnection hubConnection, String userId) =>
      hubConnection.invoke("Connect", args: [userId]);

  void sendMessage(
      HubConnection hubConnection, String receiveId, String message) {
    hubConnection.invoke("SendPrivateMessage", args: [receiveId, message]);
  }

  void sendOffer(HubConnection hubConnection,String receiverUserId,String senderId, String name, String photo, String roomId, bool isVideo) {
    hubConnection.invoke("SendOffer", args: [receiverUserId, senderId, roomId, name, photo, isVideo, 'Sent the offer']);
  }

  void sendReject(HubConnection hubConnection,String receiverUserId,String roomId) {
    debugPrint("::: Send Reject :::  $receiverUserId, $roomId");
    hubConnection.invoke("SendReject", args: [receiverUserId, roomId, 'Sent the reject']);
  }
}
