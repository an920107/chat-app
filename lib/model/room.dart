import 'dart:convert' as convert;

import 'package:chat_app/model/message.dart';

class Room {
  String id;
  List<String> userIds;
  List<String> messageIds;
  DateTime createdTime;
  DateTime updatedTime;

  List<Message> unread = [];
  Message? lastMessage;

  Room({
    required this.id,
    required this.userIds,
    required this.messageIds,
    required this.createdTime,
    required this.updatedTime,
  });

  factory Room.fromJson(
    Map<String, dynamic> json, {
    bool isSql = false,
  }) =>
      Room(
        id: json["id"],
        userIds: isSql
            ? convert.json.decode(json["users"])
            : (json["users"] as List).map((e) => e.toString()).toList(),
        messageIds: isSql
            ? convert.json.decode(json["messages"])
            : (json["messages"] as List).map((e) => e.toString()).toList(),
        createdTime: DateTime.parse(json["created_time"]),
        updatedTime: DateTime.parse(json["updated_time"]),
      );

  Map<String, dynamic> toJson({bool isSql = false}) => {
        "id": id,
        "users": isSql ? convert.json.encode(userIds) : userIds,
        "messages": isSql ? convert.json.encode(messageIds) : messageIds,
        "created_time": createdTime.toIso8601String(),
        "updated_time": updatedTime.toIso8601String(),
      };
}
