class OthersInfoUpdateBody {
  String? education;
  String? communication;
  String? jobTitle;
  String? company;
  String? heightFt;
  String? heightMesure;
  String? heightCm;
  String? smoking;
  String? drinking;
  String? familyPlan;
  List<String>? pets;
  String? religion;
  String? ethnicity;
  int? religionStatus;
  int? ethnicityStatus;
  int? educationStatus;
  int? communicationStatus;
  int? smokingStatus;
  int? drinkingStatus;
  int? familyPlanStatus;
  int? professionStatus;
  int? heightStatus;
  int? petsStatus;

  OthersInfoUpdateBody(
      {this.education,
        this.communication,
        this.jobTitle,
        this.company,
        this.heightFt,
        this.heightMesure,
        this.heightCm,
        this.smoking,
        this.drinking,
        this.familyPlan,
        this.pets,
        this.religion,
        this.ethnicity,
        this.religionStatus,
        this.ethnicityStatus,
        this.educationStatus,
        this.communicationStatus,
        this.smokingStatus,
        this.drinkingStatus,
        this.familyPlanStatus,
        this.professionStatus,
        this.heightStatus,
        this.petsStatus});

  OthersInfoUpdateBody.fromJson(Map<String, dynamic> json) {
    education = json['education'];
    communication = json['communication'];
    jobTitle = json['job_title'];
    company = json['company'];
    heightFt = json['height_ft'];
    heightMesure = json['height_mesure'];
    heightCm = json['height_cm'];
    smoking = json['smoking'];
    drinking = json['drinking'];
    familyPlan = json['family_plan'];
    pets = json['pets'].cast<String>();
    religion = json['religion'];
    ethnicity = json['ethnicity'];
    religionStatus = json['religion_status'];
    ethnicityStatus = json['ethnicity_status'];
    educationStatus = json['education_status'];
    communicationStatus = json['communication_status'];
    smokingStatus = json['smoking_status'];
    drinkingStatus = json['drinking_status'];
    familyPlanStatus = json['family_plan_status'];
    professionStatus = json['profession_status'];
    heightStatus = json['height_status'];
    petsStatus = json['pets_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['education'] = education;
    data['communication'] = communication;
    data['job_title'] = jobTitle;
    data['company'] = company;
    data['height_ft'] = heightFt;
    data['height_mesure'] = heightMesure;
    data['height_cm'] = heightCm;
    data['smoking'] = smoking;
    data['drinking'] = drinking;
    data['family_plan'] = familyPlan;
    data['pets'] = pets;
    data['religion'] = religion;
    data['ethnicity'] = ethnicity;
    data['religion_status'] = religionStatus;
    data['ethnicity_status'] = ethnicityStatus;
    data['education_status'] = educationStatus;
    data['communication_status'] = communicationStatus;
    data['smoking_status'] = smokingStatus;
    data['drinking_status'] = drinkingStatus;
    data['family_plan_status'] = familyPlanStatus;
    data['profession_status'] = professionStatus;
    data['height_status'] = heightStatus;
    data['pets_status'] = petsStatus;
    return data;
  }
}
