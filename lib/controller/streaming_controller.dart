
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:live_streaming/controller/auth_controller.dart';
import 'package:live_streaming/model/response/body/response_model.dart';
import 'package:live_streaming/model/response/body/room_body.dart';
import 'package:live_streaming/model/response/room_model.dart';
import 'package:live_streaming/src/utils/constants/m_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/repo/stream_repo.dart';
import '../model/response/body/host_info.dart';
import '../model/response/body/join_info.dart';
import '../model/response/peer_model.dart';
import 'meeting_controller.dart';
import 'package:http/http.dart' as http;

class StreamingController extends GetxController implements GetxService {
  final StreamRepo streamRepo;
  StreamingController({ required this.streamRepo});

  PickedFile? _pickedFile;
  PickedFile? get pickedFile => _pickedFile;

  bool _isOthersHost = false;
  bool get isOthersHost => _isOthersHost;

  int _offset = 1;
  int get offset => _offset;
  final int _totalSize = 0;
  int get totalSize => _totalSize;
  bool _isRoomLoading = false;
  bool get isRoomLoading => _isRoomLoading;



  /// for pk room
  final int _counter = 0;
  int get counter => _counter;

  int _finishCounter = 0;
  int get finishCounter => _finishCounter;


  setFinishCounter(){
    _finishCounter = 0;
  }

  bool _inCall = false;
  bool get inCall => _inCall;

  setInCall(bool inCall){
    _inCall = inCall;
  }

  Timer? _callTimer;
  Timer get callTimer => _callTimer!;

  int _callTimerDuration = 0;
  int get callTimerDuration => _callTimerDuration;

  setCallTimer(bool startTimer){
    if(startTimer){
      _callTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        _callTimerDuration++;
        update();
      });
    }else{
      _callTimerDuration = 0;
      _callTimer!.cancel();
    }
  }

  List<PeerModel> _peerList = [];
  List<PeerModel> get peerList => _peerList;

  addPeer(String id,String name, String avatar, int level, int age,int streamerType, int userId, int genderType) {

    /// TODO need to dynamic gender type
    String streamerRole = "";
    switch(streamerType){
      case 1:
        streamerRole = "Host";
        break;
      case 2:
        streamerRole = "Co-Host";
        break;
      case 3:
        streamerRole = "Viewer";
        break;
      default:
        streamerRole = "";
        break;
    }
    peerList.add(PeerModel(id: id, name: name, image: avatar, level: level, age: age,genderType: genderType,streamerRole: streamerRole, userId: userId));
    update();
  }

  int pkBattleResultCalculator(int hostPoint, int coHostPoint){
    if(coHostPoint > hostPoint){
      return 1;
    }else if(hostPoint > coHostPoint){
      return 2;
    }else{
      return 3;
    }
  }

  bool _isOpenGift = false;
  bool get isOpenGift => _isOpenGift;

  setOpenGift(bool val, bool notify){
    _isOpenGift = val;
    if(notify){
      update();
    }
  }
  final List<bool> _isSwitch = [];
  List<bool> get isSwitch => _isSwitch;


  toggleSwitch(int index, bool value){
    _isSwitch[index] = value;
    update();
  }


  bool _isOpenBottomSheet = false;
  bool get isOpenBottomSheet => _isOpenBottomSheet;

  openBottomSheetToggle(){
    _isOpenBottomSheet = !_isOpenBottomSheet;
    update();
  }

  int _isLiveTab = 1;
  int get isLiveTab => _isLiveTab;
  void  changeButton(int index, bool notify){
    _isLiveTab = index;
    if(notify){
      update();
    }
  }

  int _pageIndex = 1;
  int get pageIndex => _pageIndex;

  PageController? _pageController;
  PageController? get  pageController => _pageController;

  initPageCon(){
    _pageController = PageController(initialPage: 1);
  }

  void setPage(int pageIndex, ) {
    _pageController?.jumpToPage(pageIndex);
    _pageIndex = pageIndex;
    update();
  }


  /// for profile expand
  int _expandProfileIndex = 0;
  int get expandProfileIndex => _expandProfileIndex;

  void  changeExpandProfile(int index, bool notify){
    _expandProfileIndex = index;
    if(notify){
      update();
    }
  }

  bool _isExpandAllProfile = false;
  bool get isExpandAllProfile => _isExpandAllProfile;

  void  toggleExpandAllProfile(bool notify){
    _isExpandAllProfile = !_isExpandAllProfile;
    if(notify){
      update();
    }
  }

  setExpandAllProfile(bool value, bool notify){
    _isExpandAllProfile = value;
    if(notify){
      update();
    }
  }
  /// for emoji
  bool _isEmoji = false;
  bool get isEmoji => _isEmoji;

  emojiToggle(){
    _isEmoji =! _isEmoji;
    update();
  }

  /// gif index

  int _giftSentCount = 0;
  int get giftSentCount => _giftSentCount;

  void  changeGitSendCountButton(int index, bool notify){
    _giftSentCount = index;
    if(notify){
      update();
    }
  }




  void setOffset(int offset) {
    _offset = offset;
  }

  int _seatType = 0;
  int get seatType => _seatType;

  setSeatType(int index){
    _seatType = index;
    update();
  }


  void showBottomLoader() {
    _isRoomLoading = true;
    update();
  }

  void setOthersHost(bool value){
    _isOthersHost = value;
    update();
  }

  Hostinfo? _hostInfo;
  Hostinfo? get hostInfo => _hostInfo;


  List<AudioModel> _audioList = [];
  List<AudioModel> get audioList => _audioList;


  final String _liveRoomUpdatedAt = '';
  String get liveRoomUpdatedAt => _liveRoomUpdatedAt;

  void addAudio(bool notify, String hostname, String mid, String image, {bool isMute = false}){
    int duplicateIndex = checkDuplicacy(hostname);

    if(duplicateIndex == -1){
      _audioList.add(AudioModel(value: hostname, mid: mid, image: image, isMute: isMute));
      _audioList = _audioList.toSet().toList();
    }

    if(notify){
      update();
    }

  }

  int checkDuplicacy(String hostname){
    for(int i = 0; i < _audioList.length;i++ ){
      if(_audioList[i].value!.contains(hostname)){
        return i;
      }
    }
    return -1;
  }

  void removeAudioAdapter(bool notify, String mid){
    _audioList.removeWhere((element) => element.mid == mid.trim());
    if(notify){
      update();
    }
  }


  removeAudio(){
    _audioList = [];
  }



  bool _isFocus = false;
  bool get isFocus => _isFocus;

  setFocus(bool val){
    _isFocus = val;
    update();
  }

  List<int> _tagId = [];
  List<int> get tagId => _tagId;

  setTagId(int id, bool notify){
    if(checkTagIdDuplicate(id) == -1){
      _tagId.add(id);
    }

    if(notify){
      update();
    }
  }

  setTagList(List<int> id){
    _tagId = id;
    update();
  }


  int checkTagIdDuplicate(int id){
    for(int i = 0; i < _tagId.length;i++ ){
      if(_tagId[i] == id){
        return i;
      }
    }
    return -1;
  }




  List<String> _tagNameList = [];
  List<String> get tagNameList => _tagNameList;
  void  setTagName(List<String> value){
    _tagNameList = value;
    update();
  }

  List<String> _tagIdList = [];
  List<String> get tagIdList => _tagIdList;
  void setIdName(List<String> value){
    _tagIdList = value;
    update();
  }

  int _tagIndex = 0;
  int get tagIndex => _tagIndex;
  void  setTabIndex(int index){
    _tagIndex = index;
    update();
  }

  int _privacyIndex = 0;
  int get privacyIndex => _privacyIndex;


  void  setPrivacyIndex(int index){
    _privacyIndex = index;
    update();
  }

  String _privacyName = '1';
  String get privacyName => _privacyName;
  void  setPrivacyName(String value){
    _privacyName = value;
    update();
  }

  int _seatIndex = 0;
  int get seatIndex => _seatIndex;

  void  setSeatIndex(int index){
    _seatIndex = index;
    update();
  }


  bool _isFollow = false;
  bool get isFollow => _isFollow;

  void setFollow(bool notify){
    _isFollow = notify;
    update();
  }



  bool _isFollowStream = false;
  bool get isFollowStream => _isFollowStream;

  void setFollowStream(bool val, bool notify){
    _isFollowStream = val;
    if(notify){
      update();
    }
  }





  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    update();
  }


  /// for room tools

  int _toolIndex = 0;
  int get toolIndex => _toolIndex;
  void rooTools(int index , bool notify) {
    _toolIndex = index;
    if(notify){
      update();
    }
  }

  /// for Others tools

  int _othersToolIndex = 0;
  int get othersToolIndex => _othersToolIndex;

  void othersRoomTools(int index , bool notify) {
    // _isRoomToolActive = notify;
    _othersToolIndex = index;
    // update();
    if(notify){
      update();
    }
  }



  bool _isJoin = false;
  bool get isJoin => _isJoin;

  bool _isLive = false;
  bool get isLive => _isLive;

  setLive(bool value){
    _isLive = value;
    update();
  }


  setJoin(bool value, bool notify){
    _isJoin = value;
    if(notify){
      update();
    }
  }

  bool _microphoneOn = true;
  bool get microphoneOn => _microphoneOn;

  micToggle(){
    _microphoneOn = !_microphoneOn;
    update();
  }
  setMic(bool val){
    _microphoneOn = val;
    update();
  }

  ///For 4seat
  bool _cameraOn = true;
  bool get cameraOn => _cameraOn;

  setCameraToggle(bool val){
    _cameraOn = val;
    update();
  }
  cameraToggle(){
    _cameraOn =!_cameraOn;
    update();
  }

  bool _isFlip = true;
  bool get isFlip => _isFlip;

  setFlipToggle(){
    _isFlip = !_isFlip;
    update();
  }

  bool _isMirror = true;
  bool get isMirror => _isMirror;

  mirrorToggle(){
    _isMirror = !_isMirror;
    update();
  }

  setMirror(bool val){
    _isMirror = val;
    update();
  }

  int _isManageTab = 0;
  int get isManageTab  => _isManageTab;
  void changeManageButton(int index, bool notify){
    _isManageTab = index;
    if(notify){
      update();
    }
  }


  final _meetingController = Get.find<MeetingController>();
  late SharedPreferences prefs;
  String _server = '';
  String get server => _server;
  String _sid = '';
  String get sid => _sid;

  String _hostId = '';
  String get hostId => _hostId;

  @override
  @mustCallSuper
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    _server = prefs.getString('server') ?? '127.0.0.1';
    _sid = prefs.getString('room') ?? 'test room';
  }


  setSid(String value){
    _sid = value;
    update();
  }

  setHostId(String value){
    _hostId = value;
    update();
  }

  List<int> _idList = [];

  bool duplicateChecker(int id){
    if(_idList.contains(id)){
      return true;
    }
    _idList.add(id);
    return false;
  }


  int _giftGiver = 0;
  int get giftGiver => _giftGiver;
  List<int> _senderIdList = [];
  setGivers(int id){
    if(!duplicateChecker(id)){
      _giftGiver++;
    }
  }

  clearGivers(){
    _giftGiver = 0;
    _senderIdList = [];
  }

  bool duplicacyGift(int id){
    if(_senderIdList.contains(id)){
      return true;
    }
    _senderIdList.add(id);
    return false;
  }

  /// Variables
  int _countManage = 0;
  int get countManage => _countManage;

  setCountManege() {
    _countManage--;
    update();
  }

  addCountManage(){
    _countManage++;
    update();
  }

  setInitCount() {
    _countManage = 0;
    update();
  }


  bool _userIsStreaming = false;
  bool get userIsStreaming => _userIsStreaming;
  setStreaming(bool val, bool notify){
    _userIsStreaming = val;
    if(notify){
      update();
    }
  }


  bool _isFirst = true;
  bool get isFirst => _isFirst;
  setFist(bool val){
    _isFirst = val;
  }

  String _giftPath = '';
  String get giftPath => _giftPath;
  setGiftPath(String value){
    _giftPath = value;
  }
  // Floating floating = Floating();

  bool handleJoin(HandleJoin handleJoin, String receiverUserId) {
    if (_server.isEmpty || _sid.isEmpty) {
      return false;
    }

    // setHost(handleJoin.isHost);

    prefs.setString('server', _server);
    prefs.setString('room', _sid);

    _meetingController.connect(handleJoin, receiverUserId);
    setInitCount();
    _meetingController.setInitialValue();
    _microphoneOn = false;
    removeAudio();
    setLive(false);
    _meetingController.setViewCount(0);
    _meetingController.setRoomTitle( handleJoin.isHost ? '' : _hostInfo != null ? _hostInfo!.userName ?? '' : '', true);
    setStreaming(true, false);
    clearGivers();
    setCameraToggle(true);
    _meetingController.setInitialValue();
    setMic(true);
    // Navigator.push(Get.context!, CupertinoPageRoute(builder: (_) =>
    //     MeetingView(isHost: handleJoin.isHost, isViewer: handleJoin.isViewer, roomId: int.parse(_sid), isFour: handleJoin.isFour,isSix: handleJoin.isSix, isNine: handleJoin.isNine, isAudio: handleJoin.isAudio, isAuctionLive: handleJoin.isAuctionLive,
    //         isVIP: handleJoin.isVIP
    //     )));

    setJoin(false, true);
    setOthersHost(false);
    return true;
  }


  Future callEnd() async{
    _meetingController.cleanUp();
  }
  bool _isHost = false;
  bool get isHost => _isHost;

  setHost(bool val){
    _isHost = val;
  }

  int _parentId = 0;
  int get parentId => _parentId;
  setParentId(int id){
    _parentId = id;
  }


  File? _file;
  File? get file => _file;

  String? _imagePath;
  String? get imagePath => _imagePath;

  void pickImage() async{
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    _file = File.fromUri(Uri.parse(image!.path));
    //_file = _file;
    saveImage(_file!.path);
    update();
  }

  void setImagePath(String imagePath) {
    _file = File(imagePath);
    update();
  }
  void saveImage(String path) async{
    SharedPreferences saveImages = await SharedPreferences.getInstance();
    saveImages.setString('imagepath', path);
  }

  CreateRoomModel? _createRoomModel;
  CreateRoomModel? get createRoomModel => _createRoomModel;

  Hostinfo? _hostinfo;
  Hostinfo? get hostinfo => _hostinfo;


  Future<ResponseModel> createRoomBody(LiveRoomBody liveRoomBody, String token) async {
    showLoading();
    update();
    http.StreamedResponse response = await streamRepo.liveRoomBody(liveRoomBody, _file, token);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      final body = json.decode( await response.stream.bytesToString());
      _createRoomModel = CreateRoomModel.fromJson(body);
      _hostinfo = _createRoomModel!.datalist!.hostinfo;
      responseModel = ResponseModel(true, 'Room Create successfully');
    } else {
      debugPrint('object-------__OUT${json.decode( await response.stream.bytesToString())}');

      // debugPrint('object-------__${await response.stream.bytesToString()}');
       //debugPrint('object-------__${json.decode( await response.stream.bytesToString())}');
      responseModel = ResponseModel(false, '${response.reasonPhrase}');
      debugPrint('${response.statusCode} ${response.reasonPhrase}');
    }
    hideLoading();
    update();
    return responseModel;
  }


  Future<bool> handleSoloJoin(bool isHost, bool isViewer, bool isSingle, int parentId,int hostId, String seatType, {bool fromInvite = false, bool isVIP = false}) async {
    if (_server.isEmpty || _sid.isEmpty) {
      return false;
    }
    setHost(isHost);
    setParentId(parentId);
    prefs.setString('server', _server);
    prefs.setString('room', _sid);
   // _pkController.connect(isHost, isViewer, isSingle, false, seatType);
    //Get.find<ChatController>().clearChat();
    setInitCount();
   // Get.find<ChatController>().setInitReplyCount();
    //_pkController.setMicOff(false);
    _microphoneOn = false;
    removeAudio();
    // setNineSeat(isNine);
    setLive(false);
    //_pkController.setViewCount(0);
    // if(!isHost){
    //   Get.find<PKController>().setDefaultMsg(Strings.warningMsg, _sid, true);
    //   Get.find<PKController>().setDefaultMsg(Strings.welcomeMsg, _sid, true);
    // }else{
    //   setAuctionDone(false);
    //   Get.find<PKController>().setDefaultMsg(Strings.warningMsg, _sid, true);
    // }
    //_pkController.setRoomTitle( isHost ? Get.find<AuthController>().getUserName() : _hostinfo != null ? _hostinfo!.userName ?? '' : '', true);
   // clearLastViewer();
    // clearStreamingFire();
   // clearNewFan();
    clearGivers();
    /// for PK value

    if(isHost && seatType == '16'){
      hostinfo!.seatType = '16';
      hostinfo!.userId = Get.find<AuthController>().getUserId();
    }
    setStreaming(true, false);

    setCameraToggle(true);
    setMic(true);
    // Navigator.push(Get.context!, CupertinoPageRoute(builder: (_) =>
    //     SoloLiveStreamingScreen(roomId: int.parse(_sid), parentId: parentId,hostId: hostId, isSingle: isSingle, isViewer: isViewer, isVIP : isVIP
    //       // floating: floating
    //     )));
    setJoin(false, true);
    setOthersHost(false);
    KeepScreenOn.turnOn(true).then((value) => debugPrint('Keep Screen On'));
    return true;
  }



}



class AudioModel{
  String? value;
  String? mid;
  String? image;
  bool? isMute;
  AudioModel({this.value, this.mid, this.image, this.isMute});
}