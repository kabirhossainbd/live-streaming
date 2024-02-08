class ProfileModel {
  int? id;
  String? email;
  int? reactsCount;
  int? matchesCount;
  int? isVerified;
  ProfileInfo? profileInfo;
  List<ProfilePhotos>? profilePhotos;
  List<ProfileInterest>? profileInterest;
  List<ProfileInterest>? languages;
  Preferences? preferences;
  OthersInfos? othersInfos;

  ProfileModel(
      {this.id,
        this.email,
        this.reactsCount,
        this.matchesCount,
        this.isVerified,
        this.profileInfo,
        this.profilePhotos,
        this.profileInterest,
        this.languages,
        this.preferences,
        this.othersInfos});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    reactsCount = json['reacts_count'];
    matchesCount = json['matches_count'];
    isVerified = json['is_verified'];
    profileInfo = json['profile_info'] != null
        ? ProfileInfo.fromJson(json['profile_info'])
        : null;
    if (json['profile_photos'] != null) {
      profilePhotos = <ProfilePhotos>[];
      json['profile_photos'].forEach((v) {
        profilePhotos!.add(ProfilePhotos.fromJson(v));
      });
    }
    if (json['profile_interest'] != null) {
      profileInterest = <ProfileInterest>[];
      json['profile_interest'].forEach((v) {
        profileInterest!.add(ProfileInterest.fromJson(v));
      });
    }
    if (json['languages'] != null) {
      languages = <ProfileInterest>[];
      json['languages'].forEach((v) {
        languages!.add(ProfileInterest.fromJson(v));
      });
    }
    preferences = json['preferences'] != null
        ? Preferences.fromJson(json['preferences'])
        : null;
    othersInfos = json['others_infos'] != null
        ? OthersInfos.fromJson(json['others_infos'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['reacts_count'] = reactsCount;
    data['matches_count'] = matchesCount;
    data['is_verified'] = isVerified;
    if (profileInfo != null) {
      data['profile_info'] = profileInfo!.toJson();
    }
    if (profilePhotos != null) {
      data['profile_photos'] =
          profilePhotos!.map((v) => v.toJson()).toList();
    }
    if (profileInterest != null) {
      data['profile_interest'] =
          profileInterest!.map((v) => v.toJson()).toList();
    }
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    if (preferences != null) {
      data['preferences'] = preferences!.toJson();
    }
    if (othersInfos != null) {
      data['others_infos'] = othersInfos!.toJson();
    }
    return data;
  }
}

class ProfileInfo {
  int? userId;
  String? fullName;
  String? country;
  String? dob;
  String? gender;
  String? about;
  int? dobStatus;
  int? genderStatus;
  int? aboutStatus;
  String? lookingFor;
  double? latitude;
  double? longitude;
  int? nameChecked;
  int? dobChecked;
  int? genderChecked;
  int? locationStatus;

  ProfileInfo(
      {this.userId,
        this.fullName,
        this.country,
        this.dob,
        this.gender,
        this.about,
        this.dobStatus,
        this.genderStatus,
        this.aboutStatus,
        this.lookingFor,
        this.latitude,
        this.longitude,
        this.nameChecked,
        this.dobChecked,
        this.genderChecked,
        this.locationStatus,
      });

  ProfileInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    fullName = json['full_name'];
    country = json['country'];
    dob = json['dob'];
    gender = json['gender'];
    about = json['about'];
    dobStatus = json['dob_status'];
    genderStatus = json['gender_status'];
    aboutStatus = json['about_status'];
    lookingFor = json['looking_for'];
    latitude = json['latitude'].toDouble();
    longitude = json['longitude'].toDouble();
    nameChecked = json['name_checked'];
    dobChecked = json['dob_checked'];
    genderChecked = json['gender_checked'];
    locationStatus = json['location_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['full_name'] = fullName;
    data['country'] = country;
    data['dob'] = dob;
    data['gender'] = gender;
    data['about'] = about;
    data['dob_status'] = dobStatus;
    data['gender_status'] = genderStatus;
    data['about_status'] = aboutStatus;
    data['looking_for'] = lookingFor;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['name_checked'] = nameChecked;
    data['dob_checked'] = dobChecked;
    data['gender_checked'] = genderChecked;
    data['location_status'] = locationStatus;
    return data;
  }
}

class ProfilePhotos {
  int? userId;
  String? photo;
  int? position;

  ProfilePhotos({this.userId, this.photo, this.position});

  ProfilePhotos.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    photo = json['photo'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['photo'] = photo;
    data['position'] = position;
    return data;
  }
}

class ProfileInterest {
  int? id;
  int? userId;
  String? name;

  ProfileInterest({this.id, this.userId, this.name});

  ProfileInterest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    return data;
  }
}

class Preferences {
  int? id;
  int? userId;
  double? distance;
  String? showMe;
  double? ageFrom;
  double? ageTo;
  int? showMeStatus;
  String? createdAt;
  String? updatedAt;

  Preferences(
      {this.id,
        this.userId,
        this.distance,
        this.showMe,
        this.ageFrom,
        this.ageTo,
        this.showMeStatus,
        this.createdAt,
        this.updatedAt});

  Preferences.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    distance = json['distance'].toDouble();
    showMe = json['show_me'];
    ageFrom = json['age_from'].toDouble();
    ageTo = json['age_to'].toDouble();
    showMeStatus = json['show_me_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['distance'] = distance;
    data['show_me'] = showMe;
    data['age_from'] = ageFrom;
    data['age_to'] = ageTo;
    data['show_me_status'] = showMeStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OthersInfos {
  int? userId;
  String? jobTitle;
  String? company;
  int? height;
  String? education;
  String? communication;
  String? heightFt;
  int? heightCm;
  String? smoking;
  String? drinking;
  String? pets;
  String? religion;
  String? familyPlan;
  String? ethnicity;
  int? ethnicityStatus;
  int? religionStatus;
  int? familyPlanStatus;
  int? heightStatus;
  int? educationStatus;
  int? professionStatus;
  int? communicationStatus;
  int? petsStatus;
  int? drinkingStatus;
  int? smokingStatus;
  int? language;

  OthersInfos(
      {this.userId,
        this.jobTitle,
        this.company,
        this.height,
        this.education,
        this.communication,
        this.heightFt,
        this.heightCm,
        this.smoking,
        this.drinking,
        this.pets,
        this.religion,
        this.familyPlan,
        this.ethnicity,
        this.ethnicityStatus,
        this.religionStatus,
        this.familyPlanStatus,
        this.heightStatus,
        this.educationStatus,
        this.professionStatus,
        this.communicationStatus,
        this.petsStatus,
        this.drinkingStatus,
        this.smokingStatus,
        this.language});

  OthersInfos.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    jobTitle = json['job_title'];
    company = json['company'];
    height = json['height'];
    education = json['education'];
    communication = json['communication'];
    heightFt = json['height_ft'];
    heightCm = json['height_cm'];
    smoking = json['smoking'];
    drinking = json['drinking'];
    pets = json['pets'];
    religion = json['religion'];
    familyPlan = json['family_plan'];
    ethnicity = json['ethnicity'];
    ethnicityStatus = json['ethnicity_status'];
    religionStatus = json['religion_status'];
    familyPlanStatus = json['family_plan_status'];
    heightStatus = json['height_status'];
    educationStatus = json['education_status'];
    professionStatus = json['profession_status'];
    communicationStatus = json['communication_status'];
    petsStatus = json['pets_status'];
    drinkingStatus = json['drinking_status'];
    smokingStatus = json['smoking_status'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['job_title'] = jobTitle;
    data['company'] = company;
    data['height'] = height;
    data['education'] = education;
    data['communication'] = communication;
    data['height_ft'] = heightFt;
    data['height_cm'] = heightCm;
    data['smoking'] = smoking;
    data['drinking'] = drinking;
    data['pets'] = pets;
    data['religion'] = religion;
    data['family_plan'] = familyPlan;
    data['ethnicity'] = ethnicity;
    data['ethnicity_status'] = ethnicityStatus;
    data['religion_status'] = religionStatus;
    data['family_plan_status'] = familyPlanStatus;
    data['height_status'] = heightStatus;
    data['education_status'] = educationStatus;
    data['profession_status'] = professionStatus;
    data['communication_status'] = communicationStatus;
    data['pets_status'] = petsStatus;
    data['drinking_status'] = drinkingStatus;
    data['smoking_status'] = smokingStatus;
    data['language'] = language;
    return data;
  }
}
