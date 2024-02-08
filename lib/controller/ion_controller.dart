import 'package:flutter_ion/flutter_ion.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';


class IonController extends GetxController implements GetxService {
  SharedPreferences? _prefs;
  late String _sid;
  late String _name;
  final String _uid = const Uuid().v4();
  late String _displayName;
  late List<int> _extraInfo;
  late String _avatar;
  Connector? _connector;
  Room? _room;
  RTC? _rtc;

  RTCConfiguration? _rtcConfiguration;

  RTCConfiguration? get rtcConfiguration => _rtcConfiguration;

  String get sid => _sid;

  String get uid => _uid;

  String get name => _name;

  String get displayName => _displayName;

  List<int> get extraInfo => _extraInfo;

  String get avatar => _avatar;

  Room? get room => _room;

  RTC? get rtc => _rtc;

  @override
  void onInit() async {
    super.onInit();
    debugPrint('IonController::onInit');
  }

  Future<SharedPreferences> prefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  setup({required String host,
    required String room,
    required String name,
    required String displayName,
    required String avatar,
    required int userId
  }) async {
    debugPrint('IonController setup');

    List<int> streamerInfo = [];
    /// StreamerType
    /// 1 = main host
    /// 2 = streamer guest
    /// 3 = viewer
    /// 4 = caller
    /// 5 = callee

    streamerInfo.add(userId);

    _connector = Connector(host);
    _room = Room(_connector!);
    _rtc = RTC(_connector!);
    _sid = room;
    _name = name;
    _displayName = displayName;
    _extraInfo = streamerInfo;
    _avatar = avatar;
    debugPrint('IonController setup ok');
  }

  connect() async {
    await _room!.connect();
    await _rtc!.connect();
    debugPrint('IonController connect()');
  }

  joinROOM() async {
    _room!.join(
        peer: Peer()
          ..sid = _sid
          ..uid = _uid
          ..displayname = _displayName
          ..extrainfo = _extraInfo
          ..destination = ''
          ..role = Role.HOST
          ..direction = Direction.BILATERAL
          ..protocol = Protocol.WEBRTC
          ..avatar = _avatar
          ..vendor = '');
    debugPrint('joinROOM ''sid=' + sid + ' uid=' + uid + 'display name=' +displayName + 'extrainfo = '+_extraInfo.toString());
  }

  joinRTC() async {
    _rtc!.join(_sid, _uid, JoinConfig());
  }

  close() async {
    _room?.leave(_uid);
    _room?.close();
    _room = null;
  }

  subscribe(List<Subscription> info) {
    _rtc!.subscribe(info);
  }
}