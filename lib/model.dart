import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String friendMobilePhone;
  String friendName;
  String myId;
  List<ChatMessage> messages;
  Timestamp updatedAt;

  Chat({
    this.friendName,
    this.myId,
    this.messages,
    this.updatedAt,
    this.friendMobilePhone,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    myId = json['my_id'];
    friendName = json['friend_name'];
    friendMobilePhone = json['friend_mobile_phone'];
    updatedAt = json['updated_at'];
    if (json['messages'] != null) {
      messages = new List<ChatMessage>();
      json['messages'].forEach((v) {
        messages.add(new ChatMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['my_id'] = this.myId;
    data['friend_name'] = this.friendName;
    data['friend_mobile_phone'] = this.friendMobilePhone;
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ChatMessage {
  ChatUser from;
  String message;
  Timestamp createdAt;

  ChatMessage({
    this.from,
    this.message,
    this.createdAt,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    from = json['from'] != null ? new ChatUser.fromJson(json['from']) : null;
    message = json['message'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.from != null) {
      data['from'] = this.from.toJson();
    }
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class ChatUser {
  String userId;
  String userName;

  ChatUser({this.userId, this.userName});

  ChatUser.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    return data;
  }
}
