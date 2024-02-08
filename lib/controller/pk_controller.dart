import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ion/flutter_ion.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_streaming/controller/signal_controller.dart';
import 'package:live_streaming/controller/streaming_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/date_converter.dart';
import '../model/repo/stream_repo.dart';
import '../model/response/chat_model.dart';
import 'auth_controller.dart';
import 'ion_controller.dart';

class PKController extends GetxController implements GetxService  {
  final StreamRepo streamRepo;
  PKController({required this.streamRepo});

  final _ionController = Get.find<IonController>();
  late SharedPreferences prefs;
  final videoRenderers = Rx<List<VideoRendererAdapter>>([]);
  LocalStream? _localStream;

  Timer? _timer;

  late RTCDataChannel dataChannel;


  Room? get room => _ionController.room;
  RTC? get rtc => _ionController.rtc;

  final RxBool _cameraOff = false.obs;
  RxBool get cameraOff => _cameraOff;

  final RxBool _microphoneOff = false.obs;
  RxBool get microphoneOff => _microphoneOff;

  final RxBool _speakerOn = true.obs;
  RxBool get speakerOn => _speakerOn;
  // GlobalKey<ScaffoldState>? _scaffoldkey;
  // GlobalKey<ScaffoldState>? get scaffoldkey => _scaffoldkey;
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

  setMicOff(bool value){
    _microphoneOff.value = value;
  }

  setVideo(bool value){
    _isVideo = value;
    update();
  }

  // Application Lifecycle Handler
  bool _appInBackGroud = false;
  bool get appInBackGroud => _appInBackGroud;

  void setBackgroundStatus(bool value)async{
    _appInBackGroud = value;
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

  setDefaultMsg(String message, String roomId, bool notify) {
    _chatGroupList.add(ChatModel(
        messageId: '0',
        message: message,
        from: 'testUser',
        createAt: DateConverter.localDateToIsoString(DateTime.now())));
    if (notify) {
      update();
    }
  }
  /// send Streaming chat
  void setRoomChat(String message, String roomId, bool notify, String type, {String mid = '',int event = 0, int giftId = 0 ,int giftQuantity = 1, String giftName = "",int receiverUid= 0, int point = 0, int timer = 0 }) async {

    var data;

    debugPrint("::: PKRandomLive ::: setRoomChat ::: event $event type $type");

    int giftGivers = 0;

    int senderId = 1;
    String senderName = "Get.find<AuthController>().getUserName()";
    String senderLevel = "Get.find<AuthController>().getUserLevel().toString()";
    String senderPic = "Get.find<AuthController>().getUserPhoto()";
    // String roomId = mid;

    DateTime dateTime = DateTime.now();
    if(1 == 1){
      senderLevel = 'Host';
    }

    if(event == 0 && type == 'switch_camera'){

      data = {
        'senderId' : senderId,
        'name': senderName,
        'picture': senderPic,
        'level': senderLevel,
        'body': message,
        'room_id' : mid,
        'type': type
      };

      _sendDataChannel(jsonEncode(data));

    }else if(event == 0 && type == 'mirror_camera'){


      debugPrint("::: PKRandomLive ::: SendMirrorCamera ::: event $event type $type");

      data = {
        'senderId' : senderId,
        'name': senderName,
        'picture': senderPic,
        'level': senderLevel,
        'body': message,
        'room_id' : mid,
        'type': type
      };

      _sendDataChannel(jsonEncode(data));
    }else if(event == 0 && type == 'pk_switch'){

      data = {
        'body': message,
        'room_id' : roomId,
        'user_id': senderId,
        'type': type
      };

      _sendDataChannel(jsonEncode(data));

      debugPrint("::: PK_SWITCH ::: ${json.encode(data)}");

    }else{
      _sendMessage(senderId,roomId,senderName, senderLevel, message, type, event, dateTime, giftId,giftQuantity, receiverUid, point, timer);
      if(event == 0 && type == 'switch_mic'){
        if(message.contains('true')){
          //TODO connect with UI
          // updateAdapter(mid, true);
        }else if(message.contains('false')){
          //TODO connect with UI
          //updateAdapter(mid, false);
        }
      }else{
        // This block is for group message
        // if(Get.find<StreamingController>().hostinfo!.userId != senderId){
        //   Get.find<StreamingController>().setStreamerFire(80, true);
        // }

        if(_chatGroupList.isNotEmpty){
          _chatGroupList.add(ChatModel(
              messageId: senderLevel,
              message: message,
              from: "Get.find<AuthController>().getUserName()",
              type: type,
              createAt: DateConverter.localDateToIsoString(DateTime.now())));
        }else{
          _chatGroupList.add(ChatModel(
              messageId: senderLevel,
              message: message,
              from: "Get.find<AuthController>().getUserName()",
              type: type,
              createAt: DateConverter.localDateToIsoString(DateTime.now())));
        }
      }
    }

    if (notify) {
      update();
    }
  }

  clearChat() {
    _chatGroupList = [];
    update();
  }

  connect(bool isHost , bool isViewer, bool isSingle, bool isNine, String seatType) async {
    // _scaffoldkey = GlobalKey();

    int giftGivers = 0;

    /// need to dynamic
    int followCounter = 0;
    prefs = await _ionController.prefs();

    //if this client is hosted as a website, using https, the ion-backend has to be
    //reached via wss. So the address should be for example:
    //https://your-backend-address.com
    var host = prefs.getString('server') ?? '127.0.0.1';
    //host = '185.132.132.226';
    // host = '169.150.255.33';
    host = '185.100.232.17';

    host = 'http://' + host + ':5551';
    //join room
    name.value = prefs.getString('display_name') ?? 'Guest';
    rid.value = prefs.getString('room') ?? 'room1';

    int userId = 1;

    //init sfu and biz clients
    if(isHost && !isViewer){
      _ionController.setup(
          host: host, name: name.value,
          room: 'gypsy'+rid.value,
          displayName: "Get.find<AuthController>().getUserName()",
          avatar: "Get.find<AuthController>().getUserPhoto()",
          userId: userId
      );
    }else if(!isHost && isViewer){
      _ionController.setup(host: host, name: name.value,
          room: 'gypsy'+rid.value,
          displayName: "Get.find<AuthController>().getUserName()",
          avatar: "Get.find<AuthController>().getUserPhoto()",
          userId: userId
      );
    }else if(isViewer && isHost){
      if(rtc !=null) {
        rtc!.close();
      }

      _ionController.setup(host: host, name: name.value, room: 'gypsy'+rid.value,
          displayName: "Get.find<AuthController>().getUserName()",
          avatar: "Get.find<AuthController>().getUserPhoto()",
          userId: userId
      );
    }


    rtc!.ontrack = (MediaStreamTrack track, RemoteStream stream) async {
      //Get.find<StreamingController>().getLiveMemberList(int.parse(Get.find<StreamingController>().sid));

      if (track.kind == 'video') {

        if(trackId.contains(stream.id)){
          debugPrint("Duplicate Stream Came !!!");
          removeAdapter(stream.id);
          // toggleViewCount(false);
          addAdapter(await VideoRendererAdapter.create(stream.id, stream.stream, false, "", "Get.find<AuthController>().getUserPhoto()", "", false, false, false));

        }else {

          debugPrint("::: PKRandomLive OnTrack ::: isHost $isHost seatType $seatType");
          addAdapter(await VideoRendererAdapter.create(stream.id, stream.stream, false, "", "Get.find<AuthController>().getUserPhoto()", "", false, false, false));

          if(isHost && seatType == '16'){

            debugPrint("::: PKRandomLive OnTrack ::: isHost $isHost seatType $seatType");


          }
          else if(isViewer && trackId.length == 1){
            debugPrint("::: PKRandomLive OnTrack ::: isViewer $isHost seatType $seatType");
          }
          trackId.add(stream.id);

          if(isViewer == false){
            // toggleViewCount(false);
          }
        }
      }else if(track.kind == 'audio' && !_isVideo ){
        if(trackId.contains(stream.id)){
          debugPrint("Duplicate Stream Came !!!");

          // toggleViewCount(false);
        }else {
          trackId.add(stream.id);
          if(isViewer == false){
            // toggleViewCount(false);
          }
        }

      }
    };

    if(isHost && !isViewer){

      room?.onJoin = (JoinResult) async {
        debugPrint("room.onJoin");
        try {
          //join SFU
          await _ionController.joinRTC();

          // String resolution = isSingle ? 'single' : isNine ? 'nine' : 'hd';
          String resolution = 'fhd';
          var codec = prefs.getString('codec') ?? 'vp8';
          var simulcast = prefs.getBool('simulcast') ?? false;

          _localStream = await LocalStream.getUserMedia(constraints: Constraints.defaults
            ..simulcast = simulcast
            ..codec = codec
            ..resolution = resolution
            ..video = _isVideo,
          );

          rtc!.publish(_localStream!);
          addAdapter(await VideoRendererAdapter.create(_localStream!.stream.id, _localStream!.stream, true, "Get.find<AuthController>().getUserName()","Get.find<AuthController>().getUserPhoto()", "Host", false, false, false));
        } catch (error) {
          debugPrint('publish err ${error.toString()}');
        }
        _showSnackBar(":::Join success:::");
      };
    }else if(!isHost && isViewer){

      room?.onJoin = (JoinResult) async {
        debugPrint("room.onJoin");
        try {
          //join SFU
          await _ionController.joinRTC();
        } catch (error) {
          debugPrint('publish err ${error.toString()}');
        }
        _showSnackBar(":::Join success:::");
      };

    }else if(isViewer && isHost){
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
            ..resolution = 'fhd'
            ..video = _isVideo
          );

          rtc!.publish(_localStream!);
          addAdapter(await VideoRendererAdapter.create(_localStream!.stream.id, _localStream!.stream, true, "Get.find<AuthController>().getUserName()","Get.find<AuthController>().getUserPhoto()", "Co-Host", false, false, false));
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
      //todo add the name and avatar in the viewer list and streaming page
      var id = event.peer.uid;
      var name = event.peer.displayname;
      var avatar = event.peer.avatar;
      var extraInfo = event.peer.extrainfo;


      var state = '';
      switch (event.state) {
        case PeerState.NONE:
          break;
        case PeerState.JOIN:
          state = 'join';
          // Get.find<StreamingController>().setStreamerFire(5, true);
          // Get.find<StreamingController>().setStreamerHostFire(5, true);

          if(peerId.contains(event.peer.uid)){
            // toggleViewCount(false);
            debugPrint('Duplicate Peer');
          }else{
            if(extraInfo[2] == 1){

              Get.find<StreamingController>().addPeer(
                  id,
                  "Get.find<AuthController>().getUserName()",
                  "Get.find<AuthController>().getUserPhoto()",
                  1,
                  1,
                  3,
                  userId,
                  1
              );
            }else{
              Get.find<StreamingController>().addPeer(id,name, avatar, extraInfo[0], extraInfo[1],extraInfo[2], extraInfo[3],extraInfo[4]);
            }
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
      _showSnackBar(":::Peer [${event.peer.uid}:$name ], [role: ${extraInfo[2]}] $state:::");
    };

    rtc?.ontrackevent = (TrackEvent event) async {
      debugPrint("ontrackevent event.uid=${event.uid}");
      for (var track in event.tracks) {

        debugPrint("ontrackevent track.streamId=${track.stream_id} track.id=${track.id} track.kind=${track.kind} track.layer=${track.layer} track.isBlank${track.isBlank} track.muted${track.muted}");
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

            _showSnackBar(":::track-remove [$mid]:::");
            removeAdapter(mid);

            if(event.tracks[0].kind.contains("audio")){
              Get.find<StreamingController>().removeAudioAdapter(true, mid);
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
            String picture = data['picture'];

            if(message.contains('true')){
              //TODO connect with UI
              debugPrint("::: Tool ::: switch_camera : mid $mid true picture ${picture}");
              updateCameraAdapter(mid, true, picture);

            }else if(message.contains('false')){
              debugPrint("::: Tool ::: switch_camera : mid $mid false picture ${picture}");
              updateCameraAdapter(mid, false, picture);
            }

            break;
          case 'switch_mic':
            String name = data['name'];
            String level = data['level'];
            String message = data['body'];
            int senderId = data['senderId'];
            String mid = data['room_id'];

            if(message.contains('true')){
              //TODO connect with UI
              updateAdapter(mid, true);
            }else if(message.contains('false')){
              //TODO connect with UI
              updateAdapter(mid, false);
            }

            break;
          case 'mirror_camera':
            String message = data['body'];
            String mid = data['room_id'];

            if(message.contains('true')){
              updateMirrorAdapter(mid, true);
            }else if(message.contains('false')){
              updateMirrorAdapter(mid, false);
            }

            break;

          case 'gift':
            int senderId = data['senderId'];
            String name = data['name'];
            String level = data['level'];
            String type = data['type'];
            int giftId = data['giftId'];
            String giftName = data['giftName'];
            int point = data['point'];
            int giftQuantity = data['giftQuantity'];
            String message = data['body'];
            Get.find<StreamingController>().setGiftPath(message);
            Get.find<StreamingController>().setGivers(senderId);


            if(senderId > 0){
              _chatGroupList.add(ChatModel(
                  messageId: level,
                  message: '$name sent $giftName x$giftQuantity',
                  from: name,
                  type: 'gift',
                  createAt: DateConverter.localDateToIsoString(DateTime.now())));
            }

            // Set Fire Logic
            // Get.find<StreamingController>().setStreamerFire(point*100, true);

            break;
          case 'pk':
          // TODO need to add a enum for it
          /*
              Event Type
              1 = start
              2 = gift
             */
            int event = data['event'];
            if(event == 1){
              String name = data['name'];
              String level = data['level'];
              String message = 'Started a Live Match';
              String dateTime = data['dateTime'];
              String type = data['type'];
              int pkSettingsTime = data['timer'];

              final streamCon = Get.find<StreamingController>();
              _chatGroupList.add(ChatModel(
                  messageId: level.toString(),
                  message: message.toString(),
                  from: name.toString(),
                  type: type,
                  createAt: DateConverter.localDateToIsoString(DateTime.now())));

              //  TODO Update Existing Viewers Seats type
              //   Get.find<StreamingController>().hostinfo!.seatType = '16';

            }else if(event == 2){
              String name = data['name'];
              String level = data['level'];
              String type = data['type'];
              int giftId = data['giftId'];
              int receiverUid = data['receiverUid'];
              int point = data['point'];
              String message = data['body'];

              Get.find<StreamingController>().setGiftPath(message);
              // TODO need to fix sending gift
              // Get.find<CoinController>().localGiftList.forEach((element) {
              //   if(giftId.toString().trim() == element.giftId.toString().trim()){
              //     Get.find<StreamingController>().setGiftPath(element.path);
              //     Get.find<StreamingController>().toggleShowGift().then((value) {
              //       Get.find<StreamingController>().initShowGift();
              //       setGiftValue(Get.find<StreamingController>().hostinfo!.userId ?? 0,receiverUid,point, true);
              //     });
              //   }
              // });

              // Set Fire Logic
              // Get.find<StreamingController>().setStreamerFire(point*100, true);
            }
            break;
          case 'follow':
            int senderId = data['senderId'];
            String name = data['name'];
            String level = data['level'];
            // String message = "News: $name followed the anchor.";
            String type = data['type'];
            break;
          case 'groupChat':
            String name = data['name'];
            String level = data['level'];
            String message = data['body'];
            int senderId = data['senderId'];

            String roomId = data['room_id'];

            if(roomId != Get.find<StreamingController>().sid && level.contains('HOST')){
              level = 'CO-HOST';
            }

            _chatGroupList.add(ChatModel(
                messageId: level.toString(),
                message: message.toString(),
                from: name.toString(),
                createAt: DateConverter.localDateToIsoString(DateTime.now())));

            // if(Get.find<StreamingController>().hostinfo!.userId != senderId){
            //   Get.find<StreamingController>().setStreamerFire(80, true);
            // }

            break;
        }
        update();
      };
    };
  }


  removeAdapter(String mid) {
    videoRenderers.value.removeWhere((element) => element.mid == mid);
    videoRenderers.update((val) {});
  }

  addAdapter(VideoRendererAdapter adapter) {
    videoRenderers.value.add(adapter);
    videoRenderers.value =  videoRenderers.value.toSet().toList();
    videoRenderers.update((val) {});
  }

  updateAdapter(String mid, bool isMuted){
    var index = videoRenderers.value.indexWhere((element) => element.mid == mid);
    if(index != -1){
      var temp = videoRenderers.value.elementAt(index);
      temp.isMuted = isMuted;

      videoRenderers.value[index] = temp;

      // videoRenderers.update((val) { });
    }
    update();
  }

  // Update Camera Adapter
  updateCameraAdapter(String mid, bool isCameraOff, String picture){

    debugPrint("::: PKRandomLive ::: isCameraOff $isCameraOff mid $mid");

    var index = videoRenderers.value.indexWhere((element) => element.mid == mid);
    if(index != -1){

      debugPrint("::: PKRandomLive ::: isCameraOff index found => $index");

      var temp = videoRenderers.value.elementAt(index);
      temp.isCameraOff = isCameraOff;
      temp.hostPhoto = picture;
      videoRenderers.value[index] = temp;
    }



    update();
  }

  updateMirrorAdapter(String mid, bool isMirror){

    debugPrint("::: PKRandomLive ::: isMirror $isMirror mid $mid");

    var index = videoRenderers.value.indexWhere((element) => element.mid == mid);
    if(index != -1){
      var temp = videoRenderers.value.elementAt(index);
      temp.isMirror = isMirror;
      videoRenderers.value[index] = temp;

      debugPrint("::: PKRandomLive ::: isMirror index found => $index");

    }
    update();
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
    if (localVideo != null) {
      _speakerOn.value = !_speakerOn.value;
      MediaStreamTrack audioTrack = localVideo!.stream.getAudioTracks()[0];
      audioTrack.enableSpeakerphone(_speakerOn.value);
      _showSnackBar(":::Switch to " + (_speakerOn.value ? "speaker" : "earpiece") + ":::");
    }
  }

  bool _isMirror = true;
  bool get isMirror => _isMirror;

  mirrorToggle(){
    _isMirror = !_isMirror;
    String mid = localVideo!.stream.id;
    setRoomChat(_isMirror.toString(), "", true, 'mirror_camera', mid: mid);
    update();
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
      var muted = !_cameraOff.value;
      _cameraOff.value = muted;
      localVideo?.stream.getVideoTracks()[0].enabled = !muted;
      String mid = localVideo?.stream.id??'';
      debugPrint("::: switch_camera ::: ${muted.toString()}");
      localVideo?.isCameraOff =  muted;
      setRoomChat(muted.toString(), "", true, 'switch_camera', mid: mid);
    } else {
      _showSnackBar(":::Unable to operate the camera:::");
    }
  }

  //Open or close local audio
  turnMicrophone() {
    if (localVideo != null &&
        localVideo!.stream.getAudioTracks().isNotEmpty) {
      var muted = !_microphoneOff.value;
      _microphoneOff.value = muted;
      localVideo?.stream.getAudioTracks()[0].enabled = !muted;
      _showSnackBar(":::The microphone is ${muted ? 'muted' : 'unmuted'}:::");

      String mid = localVideo?.stream.id??'';

      setRoomChat(muted.toString(), "", true, 'switch_mic', mid: mid);
    } else {}
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

  Future<int> fetchTrackCount() => Future.delayed(const Duration(seconds: 10), () => trackId.length);


  void _sendMessage(int senderId,String roomId,String senderName, String senderLevel, String message, String type, int event, DateTime dateTime,
      int giftId,int giftQuantity, int receiverUid, int point,int timer, {var jsonData = null}) {

    var data = {
      'senderId' : senderId,
      'room_id' : roomId,
      'name': senderName,
      'level': senderLevel,
      'type': type,
      'giftId': giftId,
      'giftQuantity': giftQuantity,
      'receiverUid': receiverUid,
      'point': point,
      'body': message,
      'event': event,
      'dateTime': dateTime.toString(),
      'timer': timer
    };

    var body = jsonEncode(data);

    dataChannel.send(RTCDataChannelMessage(body));
  }

  void _sendDataChannel(var jsonData) {
    dataChannel.send(RTCDataChannelMessage(jsonData));
  }

  /// for multiple images
  final List<String> _imageDataList = [];
  List<String> get imageDataList => _imageDataList;
  bool _dataLoaded = true;
  bool get dataLoaded => _dataLoaded;
  //
  // void saveImages(List<String> _imageUrls) async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   for (int i = 0; i < _imageUrls.length; i++) {
  //     final response = await http.get(Uri.parse(_imageUrls[i]));
  //     if (response.statusCode == 200) {
  //       var firstPath = directory.path + "/image$i";
  //       var filePathAndName = directory.path + '/image$i.jpg';
  //       await Directory(firstPath).create(recursive: true);
  //       final file = File('${directory.path}/image$i.jpg');
  //       await file.writeAsBytes(response.bodyBytes);
  //       _imageDataList.add(filePathAndName);
  //       _dataLoaded = true;
  //       update();
  //     } else {
  //       throw Exception('Failed to save image');
  //     }
  //   }
  // }



  /// MyPkHistory tag

  int _offset = 1;
  int get offset => _offset;
  List<String> _offsetList = [];
  int _totalSize = 0;
  int get totalSize => _totalSize;
  bool _isPkHistoryLoading = false;
  bool get isPkHistoryLoading => _isPkHistoryLoading;
  bool _isPkHistoryEmpty = true;
  bool get isPkHistoryEmpty => _isPkHistoryEmpty;

  void setOffset(int offset) {
    _offset = offset;
  }
  bool _pkHistoryNoData = false;
  bool get pkHistoryNoData => _pkHistoryNoData;

  setPkHistoryNoData(bool value, bool notify) {
    _pkHistoryNoData = value;
    if (notify) {
      update();
    }
  }

  void showBottomLoader() {
    _isPkHistoryLoading = true;
    update();
  }


  bool _isPkDailyEmpty = true;
  bool get isPkDailyEmpty => _isPkDailyEmpty;

  int _hostGiftVal = 0;
  int get hostGiftVal => _hostGiftVal;

  int _coHostGiftVal = 0;
  int get coHostGiftVal => _coHostGiftVal;

  setGiftValue(int hostId,int receiverUid,int val, notify){
    if(hostId == receiverUid){
      _hostGiftVal =  _hostGiftVal+val;
    }else{
      _coHostGiftVal =  _coHostGiftVal+val;
    }

    print("HOST - $_hostGiftVal COHOST $_coHostGiftVal hostId $hostId receiverUid $receiverUid value $val ");
    if(notify){
      update();
    }

  }

  clearGiftValue(){
    _hostGiftVal = 0;
    _coHostGiftVal = 0;
  }


  /// for  pk reward ranking
  int _pkRewardRankingIndex = 0;
  int get pkRewardRankingIndex  => _pkRewardRankingIndex;
  void  changePkRewardRanking(int index, bool notify){
    _pkRewardRankingIndex = index;
    if(notify){
      update();
    }
  }

  /// for  pk Leaderboard ranking
  int _pkLeaderBoardRankingIndex = 0;
  int get pkLeaderBoardRankingIndex  => _pkLeaderBoardRankingIndex;
  void  changePkLeaderBoardRanking(int index, bool notify){
    _pkLeaderBoardRankingIndex = index;
    if(notify){
      update();
    }
  }

  /// for  pk ranking
  int _pkRankingIndex = 0;
  int get pkRankingIndex  => _pkRankingIndex;
  void  changePkRanking(int index, bool notify){
    _pkRankingIndex = index;
    if(notify){
      update();
    }
  }

  /// for  pk ranking reward
  bool _isPkRankingReward = false;
  bool get isPkRankingReward  => _isPkRankingReward;
  void  changePkRankingReward(bool val, bool notify){
    _isPkRankingReward = val;
    if(notify){
      update();
    }
  }

  /// for  combat level reward
  bool _isPkCombatLevel = false;
  bool get isPkCombatLevel  => _isPkCombatLevel;
  void  changePkCombatLevel(bool val, bool notify){
    _isPkCombatLevel = val;
    if(notify){
      update();
    }
  }

  /// for  pk reward ranking
  int _pkCombatRankingIndex = 0;
  int get pkCombatRankingIndex  => _pkCombatRankingIndex;
  void  changePkCombatRanking(int index, bool notify){
    _pkCombatRankingIndex = index;
    if(notify){
      update();
    }
  }


  int _weekQuantity = 0;
  int get weekQuantity => _weekQuantity;

  void setWeekQuantity(bool isIncrement) {
    if (isIncrement) {
      _weekQuantity = _weekQuantity + 1;
    } else {
      _weekQuantity = _weekQuantity - 1;
    }
    update();
  }


  bool _isCurrentDate = true;
  bool get isCurrentDate => _isCurrentDate;
  bool _isBeforeDate = true;
  bool get isBeforeDate => _isBeforeDate;
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  void setDateQuantity(bool isIncrement, int limit) {
    DateTime current = DateTime.now();
    if (isIncrement) {
      if(current.compareTo(_selectedDate) >= limit){
        _isBeforeDate = true;
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day + 1);
      }else{
        _isCurrentDate = false;
      }
    } else {
      if(current.difference(_selectedDate).inDays <= limit){
        _isCurrentDate = true;
        _selectedDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day - 1);
      }else{
        _isBeforeDate = false;
      }
    }
    update();
  }


  /// live match random settings
  int _connectionIndex = -1;
  int get connectionIndex => _connectionIndex;

  setConnectionIndex(int index){
    _connectionIndex = index;
    update();
  }

  int _memberTypeIndex = -1;
  int get memberTypeIndex => _memberTypeIndex;

  setMemberTypeIndex(int index){
    _memberTypeIndex = index;
    update();
  }

  int _modeTypeIndex = -1;
  int get modeTypeIndex => _modeTypeIndex;

  setModeTypeIndex(int index){
    _modeTypeIndex = index;
    update();
  }

  int _durationIndex = -1;
  int get durationIndex => _durationIndex;

  setDurationIndex(int index){
    _durationIndex = index;
    update();
  }
  String getDate(){
    return DateFormat('yyyy-MM-d').format(_selectedDate);
  }

  void cleanUpRoom(Hostinfo? hostinfo) {
    final streamCon =  Get.find<StreamingController>();
    try {
      cleanUp();
    }catch(e){
      debugPrint(e.toString());
    }
    clearChat();
    // Get.find<StreamingController>().setStreamerFire( Get.find<StreamingController>().streamerFire, true);
    // Get.find<StreamingController>().setGivers(giftGivers++);
    // Get.find<StreamingController>().setNewFans(followCounter++, 0);
    // Get.find<StreamingController>().setStreamerHostFire( Get.find<StreamingController>().streamerHostFire, true);

    clearChat();
    clearGiftValue();
    streamCon.setFinishCounter();
    streamCon.setStreaming(false, true);
  }
}

class PkBattlePoint {
  int? hostPoint;
  int? coHostPoint;
  PkBattlePoint({this.hostPoint, this.coHostPoint});

  PkBattlePoint.fromJson(Map<String, dynamic> json) {
    hostPoint = json['hostPoint'];
    coHostPoint = json['co_hostPoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hostPoint'] = hostPoint;
    data['co_hostPoint'] = coHostPoint;
    return data;
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
  bool isMirror = false;
  bool isCameraOff = false;

  VideoRendererAdapter._internal(this.mid, this.stream, this.local, this.hostName,this.hostPhoto, this.hostRole, this.isMuted, this.isMirror, this.isCameraOff);

  static Future<VideoRendererAdapter> create(String mid, MediaStream stream, bool local, String hostName, String hostPhoto, String hostRole, bool isMuted, bool isMirror, bool isCameraOff) async {
    var renderer = VideoRendererAdapter._internal(mid, stream, local, hostName, hostPhoto, hostRole, isMuted, isMirror, isCameraOff);
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
      debugPrint('dispose for texture id ' + renderer!.textureId.toString());
      renderer?.srcObject = null;
      await renderer?.dispose();
      renderer = null;
    }
  }
}