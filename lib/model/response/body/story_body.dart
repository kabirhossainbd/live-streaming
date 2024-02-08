import 'dart:convert';

class StoryBody {
  String? image;
  String? imageUrl;
  String? audio;
  String? video;
  String? text;
  String? color;
  int? storyStatus;
  String? fontFamily;
  String? length;
  String? thumbnail;
  String? storyType;
  int? storyId;
  String? viewer;
  int? download;
  int? screenShot;
  String? runningTime;
  List<int?>? usersToAdd;
  List<int?>? usersToRemove;

  StoryBody({this.image,this.imageUrl, this.audio, this.video, this.text, this.color, this.storyStatus, this.fontFamily, this.thumbnail, this.length, this.storyType,
    this.storyId,
    this.viewer,
    this.download,
    this.screenShot,
    this.runningTime,
    this.usersToAdd,
    this.usersToRemove
  });

  @override
  String toString() {
    return 'StoryBody{image: $image, imageUrl: $imageUrl, audio: $audio, video: $video, text: $text, color: $color, storyStatus: $storyStatus, fontFamily: $fontFamily, videoLength: $length, thumbnail: $thumbnail, storyType: $storyType}';
  }

  StoryBody.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    imageUrl = json['image_url'];
    audio = json['audio'];
    video = json['video'];
    text = json['text'];
    color = json['color'];
    storyStatus = json['story_status'];
    fontFamily = json['font_family'];
    length = json['video_length'];
    thumbnail = json['thumbnail'];
    storyType = json['story_type'];
    storyId = json['story_id'];
    viewer = json['viewer'];
    download = json['download'];
    screenShot = json['screenShot'];
    runningTime = json['running_time'];
    usersToAdd = json['users_to_add'].cast<int>();
    usersToRemove = json['users_to_remove'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['image_url'] = imageUrl;
    data['audio'] = audio;
    data['video'] = video;
    data['text'] = text;
    data['color'] = color;
    data['story_status'] = storyStatus;
    data['font_family'] = fontFamily;
    data['video_length'] = length;
    data['thumbnail'] = thumbnail;
    data['story_type'] = storyType;
    data['story_id'] = storyId;
    data['viewer'] = viewer;
    data['download'] = download;
    data['screenShot'] = screenShot;
    data['running_time'] = runningTime;
    data['users_to_add'] = jsonEncode(usersToAdd) ;
    data['users_to_remove'] = jsonEncode(usersToRemove);
    return data;
  }
}
