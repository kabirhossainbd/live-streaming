class EventModel {
  int? id;
  String? name;
  String? des;
  String? image;
  String? createAt;
  bool? isBoost;
  String? location;
  bool? isMatched;
  bool? requestDecline;
  bool? waiting;

  EventModel(
      {this.id,
        this.name,
        this.des,
        this.image,
        this.createAt,
        this.isBoost,
        this.location,
        this.isMatched,
        this.requestDecline,
        this.waiting});

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    des = json['des'];
    image = json['image'];
    createAt = json['createAt'];
    isBoost = json['isBoost'];
    location = json['location'];
    isMatched = json['isMatched'];
    requestDecline = json['requestDecline'];
    waiting = json['waiting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['des'] = des;
    data['image'] = image;
    data['createAt'] = createAt;
    data['isBoost'] = isBoost;
    data['location'] = location;
    data['isMatched'] = isMatched;
    data['requestDecline'] = requestDecline;
    data['waiting'] = waiting;
    return data;
  }
}
