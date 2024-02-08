
class HandleJoin {
  bool isHost = false;
  bool isViewer = false;
  bool isSingle = false;
  bool isVideo = false;
  bool isVIP = false;

  HandleJoin(
      {required this.isHost,
        required this.isViewer,
        required this.isSingle,
        required this.isVideo,
        required this.isVIP,
      });

  HandleJoin.fromJson(Map<String, dynamic> json) {
    isHost = json['isHost'];
    isViewer = json['isViewer'];
    isSingle = json['isSingle'];
    isVideo = json['isAudio'];
    isVIP = json['isVIP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isHost'] = isHost;
    data['isViewer'] = isViewer;
    data['isSingle'] = isSingle;
    data['isVideo'] = isVideo;
    data['isVIP'] = isVIP;
    return data;
  }

}