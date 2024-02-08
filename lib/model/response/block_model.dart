class BlockModel {
  int? id;
  int? userId;
  String? fullName;
  String? photo;

  BlockModel({this.id, this.userId, this.fullName, this.photo});

  BlockModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    fullName = json['full_name'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['photo'] = photo;
    return data;
  }
}
