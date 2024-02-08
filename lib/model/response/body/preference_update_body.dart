class PreferenceUpdateBody {
  double? distance;
  String? showMe;
  double? ageFrom;
  double? ageTo;
  int? showMeStatus;

  PreferenceUpdateBody({this.distance, this.showMe, this.ageFrom, this.ageTo, this.showMeStatus});

  PreferenceUpdateBody.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    showMe = json['show_me'];
    ageFrom = json['age_from'];
    ageTo = json['age_to'];
    showMeStatus = json['show_me_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['show_me'] = showMe;
    data['age_from'] = ageFrom;
    data['age_to'] = ageTo;
    data['show_me_status'] = showMeStatus;
    return data;
  }
}
