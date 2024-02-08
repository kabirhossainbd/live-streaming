import 'dart:convert';

class StorySettingsBody {
  int? storyId;
  String? viewer;
  int? download;
  int? screenShot;
  String? runningTime;
  List<int?>? usersToAdd;
  List<int?>? usersToRemove;

  StorySettingsBody(
      {this.storyId,
        this.viewer,
        this.download,
        this.screenShot,
        this.runningTime,
        this.usersToAdd,
        this.usersToRemove});

  StorySettingsBody.fromJson(Map<String, dynamic> json) {
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
