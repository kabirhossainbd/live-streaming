class GenderModel {
  int? id;
  String? gender;

  GenderModel({this.id, this.gender});

  GenderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['gender'] = gender;
    return data;
  }
}
