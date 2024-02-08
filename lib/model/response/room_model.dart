import 'package:live_streaming/model/response/body/host_info.dart';

class CreateRoomModel {
  String? status;
  String? existStatus;
  Datalist? datalist;

  CreateRoomModel({this.status, this.existStatus, this.datalist});

  CreateRoomModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    existStatus = json['exist_status'];
    datalist = json['datalist'] != null
        ? Datalist.fromJson(json['datalist'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['exist_status'] = existStatus;
    if (datalist != null) {
      data['datalist'] = datalist!.toJson();
    }
    return data;
  }
}

class Datalist {
  List<Members>? members;
  List<Members>? hostlist;
  Hostinfo? hostinfo;

  Datalist({this.members, this.hostlist, this.hostinfo});

  Datalist.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(Members.fromJson(v));
      });
    }
    if (json['hostlist'] != null) {
      hostlist = <Members>[];
      json['hostlist'].forEach((v) {
        hostlist!.add(Members.fromJson(v));
      });
    }
    hostinfo = json['hostinfo'] != null
        ? Hostinfo.fromJson(json['hostinfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (members != null) {
      data['members'] = members!.map((v) => v.toJson()).toList();
    }
    if (hostlist != null) {
      data['hostlist'] = hostlist!.map((v) => v.toJson()).toList();
    }
    if (hostinfo != null) {
      data['hostinfo'] = hostinfo!.toJson();
    }
    return data;
  }
}

class Members {
  int? id;
  int? roomId;
  int? userId;
  String? serverId;
  String? roomRole;
  String? createdAt;
  String? name;
  String? studentId;

  Members(
      {this.id,
        this.roomId,
        this.userId,
        this.serverId,
        this.roomRole,
        this.createdAt,
        this.name,
        this.studentId});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['room_id'];
    userId = json['user_id'];
    serverId = json['server_id'];
    roomRole = json['room_role'];
    createdAt = json['created_at'];
    name = json['name'];
    studentId = json['student_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['room_id'] = roomId;
    data['user_id'] = userId;
    data['server_id'] = serverId;
    data['room_role'] = roomRole;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['student_id'] = studentId;
    return data;
  }
}

