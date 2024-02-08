class PeerModel {
  String? id;
  String? name;
  String? image;
  int? level;
  int? age;
  int? genderType;
  String? streamerRole;
  int? userId;

  PeerModel({this.id, this.name, this.image, this.level, this.age, this.genderType, this.streamerRole, this.userId});

  PeerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    level = json['level'];
    age = json['age'];
    genderType = json['gender_type'];
    streamerRole = json['streamerRole'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['level'] = level;
    data['age'] = age;
    data['gender_type'] = genderType;
    data['streamerRole'] = streamerRole;
    data['userId'] = userId;
    return data;
  }
}
