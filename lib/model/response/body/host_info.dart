import '../story_model.dart';

class Hostinfo {
  int? id;
  int? userId;
  int? prentId;
  String? title;
  String? picture;
  String? seatType;
  String? roomStatus;
  int? viewcounts;
  int? following_count;
  int? follome_count;
  String? taxvalues;
  String? visitor;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? userName;
  String? email;
  String? photo;
  String? dob;
  String? gender;
  int? vipStatus;
  int? labelStatus;
  String? countryName;
  int? totalCount;
  int? followingCheckCount;


  Hostinfo(
      {this.id,
        this.userId,
        this.prentId,
        this.title,
        this.picture,
        this.seatType,
        this.roomStatus,
        this.viewcounts,
        this.following_count,
        this.follome_count,
        this.taxvalues,
        this.visitor,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.userName,
        this.email,
        this.photo,
        this.dob,
        this.gender,
        this.vipStatus,
        this.labelStatus,
        this.countryName,
        this.totalCount,
        this.followingCheckCount,
      });

  Hostinfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    prentId = json['prent_id'];
    title = json['title'];
    picture = json['picture'];
    seatType = json['seat_type'];
    roomStatus = json['room_status'];
    viewcounts = json['viewcounts'];
    following_count = json['following_count'];
    follome_count = json['follome_count'];
    taxvalues = json['taxvalues'];
    visitor = json['visitor'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    userName = json['user_name'];
    email = json['email'];
    photo = json['photo'];
    dob = json['dob'];
    gender = json['gender'];
    vipStatus = json['vip_status'];
    labelStatus = json['label_status'];
    countryName = json['country_name'];
    totalCount = json['total_participant_count'];
    followingCheckCount = json['followingcheck_count'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['prent_id'] = prentId;
    data['title'] = title;
    data['picture'] = picture;
    data['seat_type'] = seatType;
    data['room_status'] = roomStatus;
    data['viewcounts'] = viewcounts;
    data['following_count'] = follome_count;
    data['follome_count'] = follome_count;
    data['taxvalues'] = taxvalues;
    data['visitor'] = visitor;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    data['user_name'] = userName;
    data['email'] = email;
    data['photo'] = photo;
    data['dob'] = dob;
    data['gender'] = gender;
    data['vip_status'] = vipStatus;
    data['label_status'] = labelStatus;
    data['country_name'] = countryName;
    data['total_participant_count'] = totalCount;
    data['followingcheck_count'] = followingCheckCount;
    return data;
  }
}