
import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:live_streaming/controller/meeting_controller.dart';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/hub_connection.dart';

import '../model/repo/signal_repo.dart';
import '../model/response/message_model.dart';
import '../services/signal_service.dart';
import '../src/data/datasource/local/database_repository.dart';
import 'auth_controller.dart';

class SignalRController extends GetxController implements GetxService{
  final SignalRepo signalRepo;
  late SignalRService signalRService;
  late HubConnection hubConnection;

  List<MessageModel> _messageList = [];
  List<MessageModel> get messageList => _messageList;

  /// for bottom loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;


  final Logger _logger = Logger();

  SignalRController({required this.signalRepo});

  Future<void> loginSignal()async {
    signalRService = SignalRService();
    hubConnection = signalRService.hubConnection;
  }

  void reset() async {
    try{
      var connectionState = hubConnection.state;
      if(connectionState != HubConnectionState.Connected) {
        loginSignal();
      }
    }catch(e){
      signalRService = SignalRService();
      hubConnection = signalRService.hubConnection;
    }
  }

  Future<void> setNick(String nick) async{

    hubConnection = signalRService.hubConnection;
    signalRepo.setNick(hubConnection, nick);
    _logger.i("CloudSignal Nick Set $nick");
  }

  bool isLink(String input) {
    final matcher =  RegExp(r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.hasMatch(input);
  }

  Future<void> sendMessage(String receiverId, String photo, String receiverUserName, String message, {bool isReply = false}) async {

    String type = 'text';

    if(message.isNotEmpty && isLink(message)){
      type = 'Send attachment';
    }else{
      type = message;
    }

    if(hubConnection.state != HubConnectionState.Connected){
      await loginSignal().then((value) {
        signalRepo.sendMessage(hubConnection, receiverId, message);
      });
    }else{
      signalRepo.sendMessage(hubConnection, receiverId, message);
    }


    String messageId = _generateMessageId();

    MessageModel messageModel = MessageModel(
      receiverUserName, photo, 1, receiverId,
      messageId: messageId,
      message: message,
      count: 0,
      replyMsg: "",
      type: 0,
      lastMessage: type,
      isMe: 1,
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString()
    );

    _messageList.add(messageModel);


    update();
  }

  void receivedMessage(var arguments) async{
    if(arguments.isNotEmpty){
      Map<String, dynamic> data = arguments[0];

      MessageModel messageModel = MessageModel(
          data['senderUserName'], "", 1, data['senderId'],
          messageId: data["messageId"],
          message: data['message'],
          count: 0,
          replyMsg: "",
          type: 0,
          lastMessage: data['message'],
          isMe: 0,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString()
      );

      _messageList.add(messageModel);


      update();
    }
  }

  //Todo need to remove it from backend , message should come here
  void receiveRequestMessage(var arguments)async{
    if(arguments.isNotEmpty){
      Map<String, dynamic> data = arguments[0];

      MessageModel messageModel = MessageModel(
          data['senderUserName'], "", 1, data['senderId'],
          messageId: data["messageId"],
          message: data['message'],
          count: 0,
          replyMsg: "",
          type: 0,
          lastMessage: data['message'],
          isMe: 0,
          createdAt: DateTime.now().toString(),
          updatedAt: DateTime.now().toString()
      );

      _messageList.add(messageModel);

      update();
    }
  }

  void sendOffer(String receiverUserId, int senderId, String name, String photo, String roomId, bool isVideo)async{
    if(hubConnection.state != HubConnectionState.Connected){
      await loginSignal().then((value) {
        signalRepo.sendOffer(hubConnection, receiverUserId, senderId.toString(),name, photo, roomId, isVideo);
      });
    }else{
      signalRepo.sendOffer(hubConnection, receiverUserId, senderId.toString(), name, photo, roomId, isVideo);
    }

  }

  void sendReject(String receiverUserId, String roomId)async{
    if(hubConnection.state != HubConnectionState.Connected){
      await loginSignal().then((value) {
        signalRepo.sendReject(hubConnection, receiverUserId, roomId);
      });
    }else{
      signalRepo.sendReject(hubConnection, receiverUserId, roomId);
    }

  }

  void showCallingWindow(var arguments){

    if(arguments.isNotEmpty){
      Map<String, dynamic> data = arguments[0];

      bool isVideo = data['isVideo'];

      if(isVideo){
        debugPrint("::: ReceiveInvitation ::: senderid ${data['senderId']} roomId ${data['roomId']} ::: video");
        //Get.to(IncomingCallingScreen(receiverUserId: data['senderId'], roomId: data['roomId'],));
      }else{
        //Get.to(IncomingCallingScreen(receiverUserId: data['senderId'], roomId: data['roomId'],));
        debugPrint("::: ReceiveInvitation ::: roomId ${data['roomId']} ::: audio");
      }
    }else{
      _logger.e("Invitation Arguments is Empty");
    }

  }

  void terminateStreaming(var arguments) {
    if (arguments.isNotEmpty) {
      Map<String, dynamic> data = arguments[0];


      Get.find<MeetingController>().cleanUpRoom();

    }
  }
  void callRejection(var arguments) {
    if (arguments.isNotEmpty) {
      String roomId = arguments[0];
      Get.find<MeetingController>().cleanUpRoom();
      Get.back();
    }
  }



void logout() async{
  if(hubConnection.state != HubConnectionState.Connected){
    await loginSignal().then((value) {
      signalRService.dispose();
    });
  }
  signalRService.dispose();
}

  String _generateMessageId() {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int randPart = Random().nextInt(10000);
    String uniqueId = '$currentTime$randPart';
    return uniqueId.substring(uniqueId.length - 8);
  }


}