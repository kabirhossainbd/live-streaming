class RegistrationBody {
  String? email;
  String? password;
  String? fullName;
  String? country;
  String? latitude;
  String? longitude;
  String? dob;
  String? gender;
  String? lookingFor;
  String? interest;
  int? emailMarketing;

  RegistrationBody(
      {this.email,
        this.password,
        this.fullName,
        this.country,
        this.latitude,
        this.longitude,
        this.dob,
        this.gender,
        this.lookingFor,
        this.interest,
        this.emailMarketing,
      });

  RegistrationBody.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    fullName = json['full_name'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    dob = json['dob'];
    gender = json['gender'];
    lookingFor = json['looking_for'];
    interest = json['interest'];
    emailMarketing = json['email_marketing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['full_name'] = fullName;
    data['country'] = country;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['dob'] = dob;
    data['gender'] = gender;
    data['looking_for'] = lookingFor;
    data['interest'] = interest;
    data['email_marketing'] = emailMarketing;
    return data;
  }
}
