import 'dart:convert' as convert;

import 'package:chat_app/model/message.dart';

class Room {
  String id;
  String name;
  List<String> userIds;
  List<String> messageIds;
  bool isStatic;
  DateTime createdTime;
  DateTime updatedTime;

  List<Message> unread = [];

  Room({
    required this.id,
    required this.name,
    required this.userIds,
    required this.messageIds,
    required this.isStatic,
    required this.createdTime,
    required this.updatedTime,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json["id"],
      name: json["name"],
      userIds: (convert.json.decode(json["users"]) as List)
          .map((e) => e.toString())
          .toList(),
      messageIds: (convert.json.decode(json["messages"]) as List)
          .map((e) => e.toString())
          .toList(),
      isStatic: json["is_static"] != 0,
      createdTime: DateTime.parse(json["created_time"]),
      updatedTime: DateTime.parse(json["updated_time"]),
    );
  }
}
