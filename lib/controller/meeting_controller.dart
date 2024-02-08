
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ion/flutter_ion.dart';
import 'package:live_streaming/controller/auth_controller.dart';
import 'package:live_streaming/controller/signal_controller.dart';
import 'package:live_streaming/controller/streaming_controller.dart';
import 'package:live_streaming/model/response/body/join_info.dart';

import '../model/response/chat_model.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ion_controller.dart';

class MeetingController extends GetxController implements GetxService  {
  final _ionController = Get.find<IonController>();
  late SharedPreferences prefs;
  final videoRenderers = Rx<List<VideoRendererAdapter>>([]);
  LocalStream? _localStream;

  Timer? _timer;

  late RTCDataChannel dataChannel;

  Room? get room => _ionController.room;
  RTC? get rtc => _ionController.rtc;
  RTCConfiguration? get rtcConfiguration => _ionController.rtcConfiguration;

  final RxBool _cameraViewOn = false.obs;
  RxBool get cameraViewOn => _cameraViewOn;


  final RxBool _microphoneViewOn = false.obs;
  RxBool get microphoneViewOn => _microphoneViewOn;

  setInitialValue(){
    _cameraViewOn.value = false;
    _microphoneViewOn.value = false;
    refresh();
  }
  final RxBool _speakerOn = true.obs;
  RxBool get speakerOn => _speakerOn;

  var name = ''.obs;
  var rid = ''.obs;
  TrackEvent? trackEvent;

  bool _isHost = true;
  bool get isHost => _isHost;

  bool _isVideo = true;
  bool get isVideo => _isVideo;

  String? _roomTitle;
  String? get roomTitle => _roomTitle;

  setRoomTitle(String value, bool notify){
    _roomTitle = value;
    if(notify){
      update();
    }
  }


  setVideo(bool value){
    _isVideo = value;
    update();
  }



  // int _viewerCount = 0;
  // int get viewerCount => _viewerCount;
  var viewerCount = 0.obs ;

  toggleViewCount(bool value){
    if(value){
      viewerCount.value += 1 ;
    }else{
      viewerCount.value -= 1;
    }
  }

  setViewCount(int index){
    viewerCount.value = index;

  }


  setHost(bool value){
    _isHost = value;
    update();
  }

  int count = 1;
  var trackId = [];
  var peerId= [];


  List<ChatModel> _chatGroupList = [];
  List<ChatModel> get chatGroupList => _chatGroupList;

  /// send Streaming chat
  void setRoomChat(String message, String roomId, bool notify, String type, {String mid = '', int seatType = 0,int event = 0, int giftId = 0 , String giftName = "",int giftQuantity = 1, int receiverUid= 0, int point = 0, String roomType = ''}) async {

    int senderId = 1;
    String senderName = '';
    String photo = '';
    String senderLevel = 'Host';

    roomId = (mid.isEmpty) ? roomId : mid;

    DateTime dateTime = DateTime.now();
    // if(Get.find<AuthController>().getUserId() == Get.find<StreamingController>().hostinfo!.userId){
    //   senderLevel = 'Host';
    // }
    sendMessage(senderId,roomId, seatType,roomType,senderName, photo, senderLevel, message, type, event, dateTime, giftId,giftName, giftQuantity, receiverUid, point);

    if(type == 'switch_camera'){
      if(message.contains('true')){
        debugPrint("::: Tool ::: switch_camera : mid $mid true picture not coming");
        updateCameraAdapter(mid, true);
      }else if(message.contains('false')){
        //TODO connect with UI
        // Get.find<StreamingController>().setMute(false);
        // showCustomToast(getTranslated('the_host_mic_is_on', Get.context!)!);
        debugPrint("::: Tool ::: switch_camera : mid $mid false picture not coming");
        updateCameraAdapter(mid, false);
      }
    }else if(type == 'switch_mic'){
      if(message.contains('true')){
        //TODO connect with UI
        // showCustomToast(getTranslated('mic_is_off', Get.context!)!);
        updateAdapter(mid, true);
      }else if(message.contains('false')){
        //TODO connect with UI
        // showCustomToast(getTranslated('mic_is_on', Get.context!)!);
        updateAdapter(mid, false);
      }
    }

    if (notify) {
      update();
    }
  }

  connect(HandleJoin handleJoin, String receiverUserId, {String roomId = ''}) async {


    prefs = await _ionController.prefs();
    var streamController = Get.find<StreamingController>();
    //if this client is hosted as a website, using https, the ion-backend has to be
    //reached via wss. So the address should be for example:
    //https://your-backend-address.com
    var host = prefs.getString('server') ?? '127.0.0.1';
    host = '185.100.232.17';
    host = 'http://$host:5551';
    //join room
    name.value = prefs.getString('display_name') ?? 'Guest';
    rid.value = (handleJoin.isViewer) ? '' : receiverUserId;

    //init sfu and biz clients
    _ionController.setup(host: host, name: name.value, room: 'lovorise_room${rid.value}', displayName: "", avatar: "", userId: 1);

    rtc!.ontrack = (MediaStreamTrack track, RemoteStream stream) async {
      //Get.find<StreamingController>().getLiveMemberList(int.parse(Get.find<StreamingController>().sid));

      if (track.kind == 'video') {
        debugPrint("Got an video");
        if(trackId.contains(stream.id)) {
          debugPrint("Duplicate Stream Came !!!");
          removeAdapter(stream.id);
          // toggleViewCount(false);

          // addAdapter(await VideoRendererAdapter.create(stream.id, stream.stream, false));
        }

        addAdapter(await VideoRendererAdapter.create(stream.id, stream.stream, false, "hello","", "host", false, false));

        trackId.add(stream.id);
      }else if(track.kind == 'audio' && !_isVideo ){
        debugPrint("Got an Audio");

        track.enableSpeakerphone(false);

        if(trackId.contains(stream.id)){
          debugPrint("Duplicate Stream Came !!!");
          streamController.addAudio(true, "hello", stream.id, "");

        }else {
          streamController.addAudio(true, "", stream.id, "");

          trackId.add(stream.id);
        }

      }else{
        debugPrint("Got an nothing");
        track.enableSpeakerphone(false);
        streamController.setInCall(true);
        streamController.setCallTimer(true);
      }
    };

    if(isHost && !handleJoin.isViewer){

      room?.onJoin = (JoinResult) async {
        debugPrint("room.onJoin");
        try {
          //join SFU
          await _ionController.joinRTC();

          // String resolution = isSingle ? 'single' : isNine ? 'nine' : 'hd';
          String resolution = 'shd';
          var codec = prefs.getString('codec') ?? 'vp8';
          var simulcast = prefs.getBool('simulcast') ?? false;

          _localStream = await LocalStream.getUserMedia(constraints: Constraints.defaults
            ..simulcast = simulcast
            ..codec = codec
            ..resolution = resolution
            ..video = handleJoin.isVideo,
          );

          rtc!.publish(_localStream!);

          addAdapter(await VideoRendererAdapter.create(_localStream!.stream.id, _localStream!.stream, true, "hello","", "Host", false, false));

          var authController = Get.find<AuthController>();

          Get.find<SignalRController>().sendOffer(receiverUserId, 1,'', '', "lovorise_room$receiverUserId", handleJoin.isVideo);

        } catch (error) {
          debugPrint('publish err ${error.toString()}');
        }
        _showSnackBar(":::Join success:::");
      };
    }else if(handleJoin.isViewer && handleJoin.isHost){
      room?.onJoin = (JoinResult) async {
        debugPrint("room.onJoin");
        try {

          await _ionController.joinRTC();

          //join SFU
          var codec = prefs.getString('codec') ?? 'vp8';
          var simulcast = prefs.getBool('simulcast') ?? false;

          //TODO add the _localStream!.stream.id as hosts serverID for tracing leave

          _localStream = await LocalStream.getUserMedia(constraints: Constraints.defaults
            ..simulcast =  simulcast
            ..codec = codec
            ..resolution = 'shd'
            ..video = handleJoin.isVideo
          );

          rtc!.publish(_localStream!);
          addAdapter(await VideoRendererAdapter.create(_localStream!.stream.id, _localStream!.stream, true, "","", "Co-Host", false, false));
        } catch (error) {
          debugPrint('publish err ${error.toString()}');
        }
        _showSnackBar(":::Join success:::");
      };
    }

    room?.onLeave = (String reason) {
      _showSnackBar(":::Leave success:::");
    };

    room?.onPeerEvent = (PeerEvent event) {
      var name = event.peer.displayname;
      var state = '';
      switch (event.state) {
        case PeerState.NONE:
          break;
        case PeerState.JOIN:
          state = 'join';

          if(peerId.contains(event.peer.uid)){
            // toggleViewCount(false);
            debugPrint('Duplicate Peer');
          }else{

            peerId.add(event.peer.uid);
            toggleViewCount(true);
          }
          break;
        case PeerState.UPDATE:
          state = 'update';
          break;
        case PeerState.LEAVE:
          state = 'leave';


          toggleViewCount(false);
          if(peerId.contains(event.peer.uid)){
            peerId.remove(event.peer.uid);
          }
          break;
      }
      _showSnackBar(":::Peer [${event.peer.uid}:$name] $state:::");
    };

    rtc?.ontrackevent = (TrackEvent event) async {
      debugPrint("ontrackevent event.uid=${event.uid}");
      for (var track in event.tracks) {
        debugPrint("ontrackevent track.id=${track.id} track.kind=${track.kind} track.layer=${track.layer}");
      }
      switch (event.state) {
        case TrackState.ADD:
          if (event.tracks.isNotEmpty) {
            var id = event.tracks[0].id;
            _showSnackBar(":::track-add [$id]:::");
          }

          if (trackEvent == null) {
            debugPrint("trackEvent == null");
            trackEvent = event;
          }

          break;
        case TrackState.REMOVE:
          if (event.tracks.isNotEmpty) {
            var mid = event.tracks[0].stream_id;
            removeAdapter(mid);

            if(event.tracks[0].kind.contains("audio")){
              Get.find<StreamingController>().removeAudioAdapter(true, mid);
            }
            String serverId = '';

            _showSnackBar(":::track-remove [$mid]::: Host ::: [$serverId] ::: event ::: [${event.tracks[0].muted}]");
            Get.back();
            streamController.setInCall(false);
            streamController.setCallTimer(false);

            if(serverId.contains(mid)){
              try {
                cleanUp();
              }catch(e){
                debugPrint(e.toString());
              }
              // Navigator.pushAndRemoveUntil(Get.context!, PageTransition(child:  EndLiveStreamingScreen(pageIndex: 0, hostinfo: _hostInfo, viewerCount: viewerCount.value,), type: PageTransitionType.bottomToTop), (route) => false);
            }
          }
          break;
        case TrackState.UPDATE:
          if (event.tracks.isNotEmpty) {
            var id = event.tracks[0].id;
            _showSnackBar(":::track-update [$id]:::");
          }
          break;
      }
    };

    //connect to room and SFU
    await _ionController.connect();

    _ionController.joinROOM();

    var random = Random();
    var randomNumber = random.nextInt(1000000);

    // debugPrint('***** ${randomNumber}');

    dataChannel = await rtc!.createDataChannel(randomNumber.toString());

    rtc!.ondatachannel = (RTCDataChannel dataChannel){
      dataChannel.onMessage = (RTCDataChannelMessage message){
        // String receivedMessage = message.text;

        var data = jsonDecode(message.text);

        switch(data['type']){
          case 'switch_camera':
            String name = data['name'];
            String level = data['level'];
            String message = data['body'];
            int senderId = data['senderId'];
            String mid = data['room_id'];

            if(message.contains('true')){
              debugPrint("::: Tool ::: switch_camera : mid $mid true picture not coming");
              updateCameraAdapter(mid, true);
            }else if(message.contains('false')){
              debugPrint("::: Tool ::: switch_camera : mid $mid false picture not coming");
              updateCameraAdapter(mid, false);
            }

            break;
          case 'switch_mic':
            String name = data['name'];
            String level = data['level'];
            String message = data['body'];
            String mid = data['room_id'];

            if(message.contains('true')){
              //TODO connect with UI
              // showCustomToast(getTranslated('the_host_mic_is_off', Get.context!)!);
              updateAdapter(mid, true);
            }else if(message.contains('false')){
              //TODO connect with UI
              // showCustomToast(getTranslated('the_host_mic_is_on', Get.context!)!);
              updateAdapter(mid, false);
            }
            break;
        }

        update();
      };
    };
  }

  stopLocalStreaming(){
    var track = _localStream?.getTrack('video');
    track!.stop();
    debugPrint('Track Stopped');
  }

  removeAdapter(String mid) {
    videoRenderers.value.removeWhere((element) => element.mid == mid);
    videoRenderers.update((val) {});
  }

  addAdapter(VideoRendererAdapter adapter) {
    if(!adapter.hostRole.contains('Co-host')){
      videoRenderers.value.insert(0, adapter);
    }else{
      videoRenderers.value.add(adapter);
    }

    //videoRenderers.value = videoRenderers.value.toSet().toList();
    videoRenderers.update((val) {});
  }

  updateAdapter(String mid, bool isMuted){
    var index = videoRenderers.value.indexWhere((element) => element.mid == mid);
    if(index != -1){
      videoRenderers.value[index].isMuted = isMuted;

      videoRenderers.update((val) { });
    }
  }

  updateCameraAdapter(String mid, bool isCameraOff){
    var index = videoRenderers.value.indexWhere((element) => element.mid == mid);
    if(index != -1){
      videoRenderers.value[index].isCameraOff = isCameraOff;
      videoRenderers.update((val) { });

    }
  }



  // swapAdapter(adapter) {
  //   var index = videoRenderers.value.indexWhere((element) => element.mid == adapter.mid);
  //   if (index != -1) {
  //     var temp = videoRenderers.value.elementAt(index);
  //     videoRenderers.value[0] = videoRenderers.value[index];
  //     videoRenderers.value[index] = temp;
  //   }
  // }

  //Switch speaker/earpiece
  switchSpeaker() {
      _speakerOn.value = !_speakerOn.value;
      MediaStreamTrack audioTrack = localVideo!.stream.getAudioTracks()[0];
      audioTrack.enableSpeakerphone(_speakerOn.value);
      _showSnackBar(":::Switch to ${_speakerOn.value ? "speaker" : "earpiece"}:::");
  }


  VideoRendererAdapter? get localVideo {
    VideoRendererAdapter? renderrer;
    for (var element in videoRenderers.value) {
      if (element.local) {
        renderrer = element;
        continue;
      }
    }
    return renderrer;
  }


  List<VideoRendererAdapter> get remoteVideos {
    List<VideoRendererAdapter> renderers = ([]);
    for (var element in videoRenderers.value) {
      if (!element.local) {
        renderers.add(element);
      }
    }
    return renderers;
  }

  List<VideoRendererAdapter> get streamVideos {
    List<VideoRendererAdapter> renderers = ([]);
    for (var element in videoRenderers.value) {
      renderers.add(element);
    }
    return renderers;
  }

  //Switch local camera
  switchCamera() {
    if (localVideo != null && localVideo!.stream.getVideoTracks().isNotEmpty) {
      localVideo?.stream.getVideoTracks()[0].switchCamera();
    } else {
      _showSnackBar(":::Unable to switch the camera:::");
    }
  }

  //Open or close local video
  turnCamera() {
    if (localVideo != null && localVideo!.stream.getVideoTracks().isNotEmpty) {
      var muted = !_cameraViewOn.value;
      _cameraViewOn.value = muted;
      print('------------>>>>>>>>>:: ::${muted}/${_cameraViewOn.value} ');
      localVideo?.stream.getVideoTracks()[0].enabled = !muted;
      String mid = localVideo?.stream.id??'';
      setRoomChat(muted.toString(), "", true, 'switch_camera', mid: mid);
    } else {
      _showSnackBar(":::Unable to operate the camera:::");
    }
  }

  //Open or close local audio
  turnMicrophone() {
    if (localVideo != null &&
        localVideo!.stream.getAudioTracks().isNotEmpty) {
      var muted = !_microphoneViewOn.value;
      _microphoneViewOn.value = muted;
      localVideo?.stream.getAudioTracks()[0].enabled = !muted;
      _showSnackBar(":::The microphone is ${muted ? 'muted' : 'unmuted'}:::");

      String mid = localVideo?.stream.id??'';

      setRoomChat(muted.toString(), "", true, 'switch_mic', mid: mid);
    } else {

    }
  }

  bool _isFlash = false;
  bool get isFlash => _isFlash;

  flashOn() {
    if (localVideo != null && localVideo!.stream.getVideoTracks().isNotEmpty) {
      localVideo?.stream.getVideoTracks()[0].setTorch(_isFlash);
      _isFlash = !_isFlash;
      update();
    }
  }



  cleanUp() async {
    trackId = [];
    peerId = [];

    if(_timer !=null){
      _timer!.cancel();
      _timer = null;
    }


    if (localVideo != null) {
      await _localStream!.unpublish();
    }
    try{
      rtc!.close();
    }catch(e){
      debugPrint("RTC ERROR {$e}");
    }


    for (var item in videoRenderers.value) {
      var stream = item.stream;
      try {
        // rtc!.close();
        await stream.dispose();
        item.renderer!.srcObject = null;
        await item.renderer!.dispose();
        item.renderer = null ;
      } catch (error) {
        debugPrint("Stream Dispose {$error}");
      }
    }

    videoRenderers.value.clear();
    await _ionController.close();
  }

  _showSnackBar(String message) {
    debugPrint(message);
  }

  // Future<void> checkTrackExistence(int roomId) async {
  //   int trackCount = await fetchTrackCount();
  //   if(trackCount == 0){
  //     Get.find<StreamingController>().deleteRoomRequestHost(roomId).then((value) {
  //       if(value.isSuccess!){
  //         Get.find<StreamingController>().setLastViewer(viewerCount.value);
  //         Navigator.pushAndRemoveUntil(Get.context!, PageTransition(child: const EndLiveStreamingScreen(pageIndex: 0), type: PageTransitionType.theme), (route) => false);
  //       }
  //     });
  //   }
  //
  //   debugPrint('Checking Stream  Track Done . Track Count is: $trackCount');
  //
  // }

  Future<int> fetchTrackCount() => Future.delayed(const Duration(seconds: 10), () => trackId.length);

  void sendMessage(int senderId,String roomId, int seatType,String roomType, String senderName,String photo, String senderLevel, String message, String type, int event, DateTime dateTime, int giftId, String giftName,int giftQuantity, int receiverUid, int point) {
    var data = {
      'senderId' : senderId,
      'room_id' : roomId,
      'seat_type' : seatType,
      'room_type' : roomType,
      'name': senderName,
      'photo': photo,
      'level': senderLevel,
      'type': type,
      'giftId': giftId,
      "giftName": giftName,
      'giftQuantity': giftQuantity,
      'receiverUid': receiverUid,
      'point': point,
      'body': message,
      'event': event,
      'dateTime': dateTime.toString(),
    };

    var body = jsonEncode(data);

    dataChannel.send(RTCDataChannelMessage(body));
  }

  void cleanUpRoom() {
    try {
      cleanUp();
    }catch(e){
      debugPrint(e.toString());
    }


  }
}

class BoxSize {
  BoxSize({required this.width, required this.height});
  double width;
  double height;
}

class VideoRendererAdapter {
  String mid;
  bool local;
  RTCVideoRenderer? renderer;
  MediaStream stream;
  RTCVideoViewObjectFit _objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
  String hostName = "N/A";
  String hostPhoto = "N/A";
  String hostRole = "N/A";
  bool isMuted = false;
  bool isCameraOff = false;

  VideoRendererAdapter._internal(this.mid, this.stream, this.local, this.hostName,this.hostPhoto, this.hostRole, this.isMuted, this.isCameraOff);

  static Future<VideoRendererAdapter> create(String mid, MediaStream stream, bool local, String hostName, String hostPhoto,String hostRole, bool isMuted, bool isCameraOff) async {
    var renderer = VideoRendererAdapter._internal(mid, stream, local, hostName, hostPhoto, hostRole, isMuted , isCameraOff);
    await renderer.setupSrcObject();
    return renderer;
  }

  setupSrcObject() async {
    if (renderer == null) {
      renderer = RTCVideoRenderer();
      await renderer?.initialize();
    }
    renderer?.srcObject = stream;
    if (local) {
      _objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitCover;
    }
  }

  switchObjFit() {
    _objectFit = (_objectFit == RTCVideoViewObjectFit.RTCVideoViewObjectFitContain)
        ? RTCVideoViewObjectFit.RTCVideoViewObjectFitCover
        : RTCVideoViewObjectFit.RTCVideoViewObjectFitContain;
  }

  RTCVideoViewObjectFit get objFit => _objectFit;

  set objectFit(RTCVideoViewObjectFit objectFit) {
    _objectFit = objectFit;
  }

  dispose() async {
    if (renderer != null) {
      debugPrint('dispose for texture id ${renderer!.textureId}');
      renderer?.srcObject = null;
      await renderer?.dispose();
      renderer = null;
    }
  }
}