class StoryModel {
  StoryDataList? ownStory;
  StoryObject? story;

  StoryModel({this.ownStory, this.story});

  StoryModel.fromJson(Map<String, dynamic> json) {
    ownStory = json['ownStory'] != null
        ? StoryDataList.fromJson(json['ownStory'])
        : null;
    story = json['story'] != null ? StoryObject.fromJson(json['story']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ownStory != null) {
      data['ownStory'] = ownStory!.toJson();
    }
    if (story != null) {
      data['story'] = story!.toJson();
    }
    return data;
  }
}


class StoryObject {
  int? currentPage;
  List<StoryDataList>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  StoryObject(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  StoryObject.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <StoryDataList>[];
      json['data'].forEach((v) {
        data!.add(StoryDataList.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class StoryDataList {
  int? id;
  String? name;
  String? userName;
  String? photo;
  bool isMyStory = false;
  List<Stories>? stories;
  StoryDataList({this.id, this.name, this.userName, this.photo, this.stories, this.isMyStory = false,});

  StoryDataList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['full_name'];
    userName = json['user_name'];
    photo = json['photo'];
    if (json['stories'] != null) {
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories!.add(Stories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = name;
    data['user_name'] = userName;
    data['photo'] = photo;
    if (stories != null) {
      data['stories'] = stories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Stories {
  int? id;
  String? image;
  String? video;
  String? imageUrl;
  String? storyType;
  String? audio;
  int? userId;
  String? fontFamily;
  String? videoLength;
  String? thumbnail;
  String? text;
  String? color;
  String? createdAt;
  int? totalViewerCount;
  int? reactCount;
  StorySeen? storySeen;
  StorySeen? storyReact;
  Settings? settings;
  List<StoryExcept>? storyExcept;
  List<LatestViewer>? latestViewer;

  Stories(
      {this.id,
        this.image,
        this.video,
        this.imageUrl,
        this.storyType,
        this.audio,
        this.userId,
        this.fontFamily,
        this.videoLength,
        this.thumbnail,
        this.text,
        this.color,
        this.createdAt,
        this.totalViewerCount,
        this.reactCount,
        this.storySeen,
        this.storyReact,
        this.settings,
        this.storyExcept,
        this.latestViewer
      });

  Stories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    video = json['video'];
    imageUrl = json['image_url'];
    storyType = json['story_type'];
    audio = json['audio'];
    userId = json['user_id'];
    fontFamily = json['font_family'];
    videoLength = json['video_length'];
    thumbnail = json['thumbnail'];
    text = json['text'];
    color = json['color'];
    createdAt = json['created_at'];
    totalViewerCount = json['total_viewer_count'];
    reactCount = json['react_count'];
    storySeen = json['story_seen'] != null
        ? StorySeen.fromJson(json['story_seen'])
        : null;
    storyReact = json['story_react'] != null
        ? StorySeen.fromJson(json['story_react'])
        : null;
    settings = json['settings'] != null
        ? Settings.fromJson(json['settings'])
        : null;
    if (json['story_except'] != null) {
      storyExcept = <StoryExcept>[];
      json['story_except'].forEach((v) {
        storyExcept!.add(StoryExcept.fromJson(v));
      });
    }
    if (json['latest_viewer'] != null) {
      latestViewer = <LatestViewer>[];
      json['latest_viewer'].forEach((v) {
        latestViewer!.add(LatestViewer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['video'] = video;
    data['image_url'] = imageUrl;
    data['story_type'] = storyType;
    data['audio'] = audio;
    data['user_id'] = userId;
    data['font_family'] = fontFamily;
    data['video_length'] = videoLength;
    data['thumbnail'] = thumbnail;
    data['text'] = text;
    data['color'] = color;
    data['created_at'] = createdAt;
    data['total_viewer_count'] = totalViewerCount;
    data['react_count'] = reactCount;
    if (storySeen != null) {
      data['story_seen'] = storySeen!.toJson();
    }

    if (storyReact != null) {
      data['story_react'] = storyReact!.toJson();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    if (storyExcept != null) {
      data['story_except'] = storyExcept!.map((v) => v.toJson()).toList();
    }

    if (latestViewer != null) {
      data['latest_viewer'] =
          latestViewer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StorySeen {
  int? storyId;
  int? userId;

  StorySeen({this.storyId, this.userId});

  StorySeen.fromJson(Map<String, dynamic> json) {
    storyId = json['story_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['story_id'] = storyId;
    data['user_id'] = userId;
    return data;
  }
}


class Settings {
  int? storyId;
  String? viewer;
  int? download;
  int? screenShot;
  int? runningTime;
  String? runningLimit;

  Settings(
      {this.storyId,
        this.viewer,
        this.download,
        this.screenShot,
        this.runningTime,
        this.runningLimit});

  Settings.fromJson(Map<String, dynamic> json) {
    storyId = json['story_id'];
    viewer = json['viewer'];
    download = json['download'];
    screenShot = json['screenShot'];
    runningTime = json['running_time'];
    runningLimit = json['running_limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['story_id'] = storyId;
    data['viewer'] = viewer;
    data['download'] = download;
    data['screenShot'] = screenShot;
    data['running_time'] = runningTime;
    data['running_limit'] = runningLimit;
    return data;
  }
}

class StoryExcept {
  int? id;
  int? storyId;
  int? userId;
  String? createdAt;
  String? updatedAt;

  StoryExcept(
      {this.id, this.storyId, this.userId, this.createdAt, this.updatedAt});

  StoryExcept.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storyId = json['story_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['story_id'] = storyId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


class LatestViewer {
  int? storyId;
  int? id;
  String? name;
  String? photo;
  String? userName;

  LatestViewer({this.storyId, this.id, this.name, this.photo, this.userName});

  LatestViewer.fromJson(Map<String, dynamic> json) {
    storyId = json['story_id'];
    id = json['id'];
    name = json['full_name'];
    photo = json['photo'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['story_id'] = storyId;
    data['id'] = id;
    data['full_name'] = name;
    data['photo'] = photo;
    data['user_name'] = userName;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}


