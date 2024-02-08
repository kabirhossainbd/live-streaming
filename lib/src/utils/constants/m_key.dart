
import 'package:live_streaming/model/response/language_model.dart';


class MyKey {

  /// base url
  static const String baseUrl = 'http://185.100.232.17:3021/api';

  static const String loginUri = '/login';
  static const String createRoomUri = '/live-room-create';
  static const String getRoomUri = '/live-room';
  static const String joinLiveRoomUri = '/live-room-join';


  static const String getProfileImage = '/live-room';




  ///google map api key
  static const String googleMapApiKey = 'AIzaSyBwghm409l7AEhwftY796hCejSeqJgCLAY';


  static const String theme = 'theme';
  static const String token = 'token';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static const String setMinAgeRange = 'setMinAgeRange';
  static const String setMaxAgeRange = 'setMaxAgeRange';
  static const String languageIndex = 'languageIndex';
  static const String deviceLan = 'deviceLan';
  static const String controlProfile = 'controlProfile';
  static const String onlineStatus = 'onlineStatus';
  static const String messageOn = 'messageOn';
  static const String lovoRiseTeam = 'lovoRiseTeam';
  static const String hideMyVisibility = 'hideMyVisibility';
  static const String hideMyLocation = 'hideMyLocation';
  static const String verifyTime = 'time';
  static const String isVerify = 'isVerify';
  static const String timerIndex = 'timerindex';
  static const String userPass = 'userPass';
  static const String userEmail = 'userEmail';
  static const String userName = 'userName';
  static const String userId = 'userId';
  static const String userPhoto = 'userPhoto';
  static const String countryName = 'countryName';
  static const String localCache = 'localCache';
  static const String hideRecentActiveTime = 'hideRecentActiveTime';
  static const String hideOnlineStatus = 'hideOnlineStatus';
  static const String hideLocation = 'hideLocation';
  static const String hideNotification = 'hideNotification';
  static const String hideFollowingInfo = 'hideFollowingInfo';
  static const String hideStrangerMessage = 'hideStrangerMessage';
  static const String hideMyAge = 'hideMyAge';
  static const String setShowMe = 'setShowMe';
  static const String state = 'state';
  static const String profileInfo = 'profileInfo';



  static const String isSocialLogin = 'isSocialLogin';


  static List<LanguageModel> languages = [
    LanguageModel(languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(languageName: 'Bangla', countryCode: 'BD', languageCode: 'bd'),
    LanguageModel(languageName: 'Hindi', countryCode: 'IND', languageCode: 'ind'),
  ];

  // Database
  static const String messageTableName = "messages";
  static const String rosterTableName = "rosters";
}