class NewMatchModel {
  int? id;
  String? name;
  String? image;
  String? about;
  int? age;
  String? location;
  String? love;

  NewMatchModel({this.id, this.name, this.image, this.about, this.age, this.location, this.love});

  NewMatchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    about = json['about'];
    age = json['age'];
    location = json['location'];
    love = json['love'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['about'] = about;
    data['age'] = age;
    data['location'] = location;
    data['love'] = love;
    return data;
  }
}
