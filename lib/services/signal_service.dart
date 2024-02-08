
import 'package:get/get.dart';
import 'package:live_streaming/controller/auth_controller.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../controller/signal_controller.dart';

class SignalRService{

  final Logger _logger = Logger();

  late HubConnection _hubConnection;

  SignalRService(){
    _hubConnection = HubConnectionBuilder()
        .withUrl("http://185.100.232.17:8080/chathub")
        .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 20000])
        .build();

    _hubConnection.on("ReceiveMessage", (arguments) {
      _logger.d("signalR ReceiveMessage : $arguments");
      //TODO need to move it in controller
     // LocalNotificationService.display(arguments);
      Get.find<SignalRController>().receivedMessage(arguments);
    });

    _hubConnection.on("ReceiveRequestMessage", (arguments) {
      _logger.d("signalR ReceiveRequestMessage : $arguments");
      Get.find<SignalRController>().receiveRequestMessage(arguments);
    });

    _hubConnection.on("ReceiveFileMessage", (arguments) {
      _logger.d("signalR ReceiveMessage : $arguments");
    });

    _hubConnection.on("ReceiveRequestFileMessage", (arguments) {
      _logger.d("signalR ReceiveRequestFileMessage : $arguments");
    });

    _hubConnection.on("ReceiveStoryReaction", (arguments) {
      _logger.d("signalR ReceiveStoryReaction : $arguments");
    });

    _hubConnection.on("ReceiveUser", (arguments) {
      _logger.d("Receive User: $arguments");
    });

    _hubConnection.on("ConnectionId", (arguments){
      if(arguments!.isNotEmpty){
        Get.find<SignalRController>().setNick('');
      }
    });

    _hubConnection.on("UserLogged", (arguments){
      _logger.d("SignalR Login : $arguments");
    });

    _hubConnection.on("UserLoggedOut", (arguments){
      _logger.d("SignalR Logout : $arguments");
    });

    _hubConnection.on("onlineUsers", (arguments){
      _logger.d("SignalR Current Online Users: $arguments");
      // Get.find<SignalRController>().setOnlineUser(arguments);
    });


    ///
    /// Live call
    ///
    _hubConnection.on("ReceiveLiveInvitation", (arguments){
      _logger.d("signalR ReceiveInvitation : $arguments");

      Get.find<SignalRController>().showCallingWindow(arguments);

    });

    _hubConnection.on("TerminateStreaming", (arguments){
      _logger.d("signalR ReceiveTermination : $arguments");

      Get.find<SignalRController>().terminateStreaming(arguments);
    });

    _hubConnection.on("ReceiveCallReject", (arguments){
      _logger.d("signalR ReceiveCallReject : $arguments");
      Get.find<SignalRController>().callRejection(arguments);
    });

    ///
    /// Streaming
    ///


    _hubConnection.onclose(({error}) {
      _logger.e("Connection Close: $error");
    });

    _startHubConnection();
  }

  HubConnection get hubConnection => _hubConnection;

  Future<void> _startHubConnection() async {
    try {
      await _hubConnection.start()?.then((value){
        // _hubConnection.invoke("GetConnectionId").then((value){
        //   // setConnectionString(value);
        //   // _logger.d("SignalR Connection Id : $value");
        //   //
        //   // Get.find<SignalRController>().setNick(Get.find<AuthController>().getUserId().toString());
        // });
      });

    } catch (e) {
      _logger.e("Error Connecting on Hub $e");
    }
  }

  // Future<void> reset() async{
  //   _hubConnection.stop();
  //
  //   _hubConnection = HubConnectionBuilder()
  //       .withUrl(ApiConfig.SignalRUrl+ApiConfig.SignalRChatHub)
  //       .withAutomaticReconnect(retryDelays: [2000, 5000, 10000, 20000])
  //       .build();
  //
  //   _startHubConnection();
  // }

  void dispose(){
    _logger.i("logout from Hub");
    _hubConnection.stop();
  }

}