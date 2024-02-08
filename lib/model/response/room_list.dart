class RoomModel {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  RoomModel(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  RoomModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  int? prentId;
  String? title;
  String? picture;
  String? seatType;
  int? price;
  String? categoryId;
  String? seatName;
  int? position;
  int? boostStatus;
  String? boostEndtime;
  int? deleteStatus;
  String? createdAt;
  String? name;
  String? studentId;

  Data(
      {this.id,
        this.userId,
        this.prentId,
        this.title,
        this.picture,
        this.seatType,
        this.price,
        this.categoryId,
        this.seatName,
        this.position,
        this.boostStatus,
        this.boostEndtime,
        this.deleteStatus,
        this.createdAt,
        this.name,
        this.studentId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    prentId = json['prent_id'];
    title = json['title'];
    picture = json['picture'];
    seatType = json['seat_type'];
    price = json['price'];
    categoryId = json['category_id'];
    seatName = json['seat_name'];
    position = json['position'];
    boostStatus = json['boost_status'];
    boostEndtime = json['boost_endtime'];
    deleteStatus = json['delete_status'];
    createdAt = json['created_at'];
    name = json['name'];
    studentId = json['student_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['prent_id'] = prentId;
    data['title'] = title;
    data['picture'] = picture;
    data['seat_type'] = seatType;
    data['price'] = price;
    data['category_id'] = categoryId;
    data['seat_name'] = seatName;
    data['position'] = position;
    data['boost_status'] = boostStatus;
    data['boost_endtime'] = boostEndtime;
    data['delete_status'] = deleteStatus;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['student_id'] = studentId;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
