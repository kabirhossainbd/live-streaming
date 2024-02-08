class StorySettingsModel {
  StorySettings? settings;
  List<ViewerExcept>? viewerExcept;

  StorySettingsModel({this.settings, this.viewerExcept});

  StorySettingsModel.fromJson(Map<String, dynamic> json) {
    settings = json['settings'] != null
        ? StorySettings.fromJson(json['settings'])
        : null;
    if (json['viewerExcept'] != null) {
      viewerExcept = <ViewerExcept>[];
      json['viewerExcept'].forEach((v) {
        viewerExcept!.add(ViewerExcept.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    if (viewerExcept != null) {
      data['viewerExcept'] = viewerExcept!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StorySettings {
  int? id;
  int? storyId;
  String? viewer;
  int? download;
  int? screenShot;
  int? runningTime;

  StorySettings(
      {this.id,
        this.storyId,
        this.viewer,
        this.download,
        this.screenShot,
        this.runningTime});

  StorySettings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storyId = json['story_id'];
    viewer = json['viewer'];
    download = json['download'];
    screenShot = json['screenShot'];
    runningTime = json['running_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['story_id'] = storyId;
    data['viewer'] = viewer;
    data['download'] = download;
    data['screenShot'] = screenShot;
    data['running_time'] = runningTime;
    return data;
  }
}

class ViewerExcept {
  int? id;
  int? storyId;
  int? userId;

  ViewerExcept({this.id, this.storyId, this.userId});

  ViewerExcept.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storyId = json['story_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['story_id'] = storyId;
    data['user_id'] = userId;
    return data;
  }
}
