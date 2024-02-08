import 'package:flutter/material.dart';

class StoryModel {
  int? id;
  String? profile;
  String? userName;
  List<StoryUser>? storyUser;

  StoryModel({this.id, this.profile, this.userName, this.storyUser});

  StoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profile = json['profile'];
    userName = json['userName'];
    if (json['StoryUser'] != null) {
      storyUser = <StoryUser>[];
      json['StoryUser'].forEach((v) {
        storyUser!.add(new StoryUser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['profile'] = profile;
    data['userName'] = userName;
    if (storyUser != null) {
      data['StoryUser'] = storyUser!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoryUser {
  int? suerId;
  String? storyType;
  String? media;
  double? duration;
  String? caption;
  String? time;
  Color? color;

  StoryUser(
      {this.suerId,
        this.storyType,
        this.media,
        this.duration,
        this.caption,
        this.time,
        this.color});

  StoryUser.fromJson(Map<String, dynamic> json) {
    suerId = json['suerId'];
    storyType = json['storyType'];
    media = json['media'];
    duration = json['duration'];
    caption = json['caption'];
    time = json['time'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['suerId'] = suerId;
    data['storyType'] = storyType;
    data['media'] = media;
    data['duration'] = duration;
    data['caption'] = caption;
    data['time'] = time;
    data['color'] = color;
    return data;
  }
}