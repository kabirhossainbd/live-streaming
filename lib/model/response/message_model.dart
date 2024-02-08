class ChatUserModel {
  String name = '';
  String photo = '';
  int isActive;
  String userId = "";

  ChatUserModel(this.name, this.photo, this.isActive, this.userId);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['photo'] = photo;
    data['isActive'] = isActive;
    data['userId'] = userId;
    return data;
  }
}

class MessageModel extends ChatUserModel {
  String? messageId;
  String? lastMessage;
  String? message;
  int? count;
  int? isMe;
  String? replyMsg;
  int? type;
  String? createdAt;
  String? updatedAt;

  MessageModel(String name, String photo, int isActive, String userId,
      {this.messageId,
      this.lastMessage,
      this.message,
      this.count,
      this.isMe,
      this.replyMsg,
      this.type,
      this.createdAt,
      this.updatedAt})
      : super(name, photo, isActive, userId);

  MessageModel.fromJson(Map<String, dynamic> json) : super(json['name'], json['photo'], json['isActive'], json['userId']) {
    messageId = json['messageId'];
    lastMessage = json['lastMessage'];
    message = json['message'];
    count = json['count'];
    isMe = json['isMe'];
    replyMsg = json['replyMsg'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['messageId'] = messageId;
    data['lastMessage'] = lastMessage;
    data['message'] = message;
    data['count'] = count;
    data['isMe'] = isMe;
    data['replyMsg'] = replyMsg;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class RosterMessageModel extends ChatUserModel {
  String? messageId;
  String? lastMessage;
  int? count;
  String? createdAt;
  String? updatedAt;

  RosterMessageModel(String name, String photo, int isActive, String userId,
      {this.messageId,
        this.lastMessage,
        this.count,
        this.createdAt,
        this.updatedAt})
      : super(name, photo, isActive, userId);

  RosterMessageModel.fromJson(Map<String, dynamic> json) : super(json['name'], json['photo'], json['isActive'], json['userId']) {
    messageId = json['messageId'];
    lastMessage = json['lastMessage'];
    count = json['count'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data['messageId'] = messageId;
    data['lastMessage'] = lastMessage;
    data['count'] = count;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
