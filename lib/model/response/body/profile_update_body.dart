class ProfileUpdateBody {
  String? fullName;
  String? dob;
  String? gender;
  String? lookingFor;
  String? about;
  String? age;
  int? dobStatus;
  int? genderStatus;
  int? aboutStatus;
  int? nameChecked;
  int? dobChecked;
  int? genderChecked;

  ProfileUpdateBody(
      {this.fullName,
        this.dob,
        this.gender,
        this.lookingFor,
        this.about,
        this.age,
        this.dobStatus,
        this.genderStatus,
        this.aboutStatus,
        this.nameChecked,
        this.dobChecked,
        this.genderChecked});

  ProfileUpdateBody.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    dob = json['dob'];
    gender = json['gender'];
    lookingFor = json['looking_for'];
    about = json['about'];
    age = json['age'];
    dobStatus = json['dob_status'];
    genderStatus = json['gender_status'];
    aboutStatus = json['about_status'];
    nameChecked = json['name_checked'];
    dobChecked = json['dob_checked'];
    genderChecked = json['gender_checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['dob'] = dob;
    data['gender'] = gender;
    data['looking_for'] = lookingFor;
    data['about'] = about;
    data['age'] = age;
    data['dob_status'] = dobStatus;
    data['gender_status'] = genderStatus;
    data['about_status'] = aboutStatus;
    data['name_checked'] = nameChecked;
    data['dob_checked'] = dobChecked;
    data['gender_checked'] = genderChecked;
    return data;
  }
}
