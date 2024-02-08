class StateModel {
  StateData? state;

  StateModel({this.state});

  StateModel.fromJson(Map<String, dynamic> json) {
    state = json['state'] != null ? StateData.fromJson(json['state']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (state != null) {
      data['state'] = state!.toJson();
    }
    return data;
  }
}

class StateData {
  int? userId;
  int? interest;
  int? photos;

  StateData({this.userId, this.interest, this.photos});

  StateData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    interest = json['interest'];
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['interest'] = interest;
    data['photos'] = photos;
    return data;
  }
}
