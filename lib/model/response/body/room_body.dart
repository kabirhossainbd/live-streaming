class LiveRoomBody {
  String? title;
  String? picture;
  String? seatType;
  List<int?>? tags;
  // String? tags;
  String? status;
  int? price;
  int? categoryId;
  int? serverId;

  LiveRoomBody({this.title, this.picture, this.seatType, this.tags, this.status, this.price, this.categoryId, this.serverId});

  LiveRoomBody.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    picture = json['picture'];
    seatType = json['seat_type'];
    tags = json['tags'].cast<int>();
    status = json['status'];
    price = json['price'];
    categoryId = json['category_id'];
    serverId = json['server_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['picture'] = picture;
    data['seat_type'] = seatType;
    data['tags'] = tags;
    data['price'] = price;
    data['category_id'] = categoryId;
    data['server_id'] = serverId;
    return data;
  }
}
