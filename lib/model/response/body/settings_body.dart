class SettingsBody {
  int? id;
  int? userId;
  int? age;
  int? online;
  int? visibility;
  int? location;
  String? createdAt;
  String? updatedAt;
  int? distance;
  int? notifyMessage;
  int? notifyLovorise;

  SettingsBody(
      {this.id,
        this.userId,
        this.age,
        this.online,
        this.visibility,
        this.location,
        this.createdAt,
        this.updatedAt,
        this.distance,
        this.notifyMessage,
        this.notifyLovorise});

  SettingsBody.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    age = json['age'];
    online = json['online'];
    visibility = json['visibility'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distance = json['distance'];
    notifyMessage = json['notify_message'];
    notifyLovorise = json['notify_lovorise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['age'] = age;
    data['online'] = online;
    data['visibility'] = visibility;
    data['location'] = location;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['distance'] = distance;
    data['notify_message'] = notifyMessage;
    data['notify_lovorise'] = notifyLovorise;
    return data;
  }
}
