class Message {
  String id;
  String sourceUid;
  String content;
  DateTime createdTime;
  DateTime updatedTime;

  bool isMe = false;

  Message({
    required this.id,
    required this.sourceUid,
    required this.content,
    required this.createdTime,
    required this.updatedTime,
  });

  factory Message.fromJson(Map<String, dynamic> json, {bool isSql = false}) =>
      Message(
        id: json["id"],
        sourceUid: json["source_uid"],
        content: json["content"],
        createdTime: DateTime.parse(json["created_time"]),
        updatedTime: DateTime.parse(json["updated_time"]),
      );

  Map<String, dynamic> toJson({bool isSql = false}) => {
        "id": id,
        "source_uid": sourceUid,
        "content": content,
        "created_time": createdTime.toIso8601String(),
        "updated_time": updatedTime.toIso8601String(),
      };
}
