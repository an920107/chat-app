import 'package:chat_app/model/message.dart';
import 'package:chat_app/service/local_database.dart';
import 'package:uuid/uuid.dart';

abstract class MessageLocalRepo {
  static Future<Message?> getMessage(String id) async {
    final json = await LocalDatabase.instance.query(
      "message",
      where: "id = ?",
      whereArgs: [id],
    );
    if (json.isEmpty) return null;
    return Message.fromJson(json.first);
  }

  static Future<Message> createMessage(String sourceUid, String content) async {
    const uuid = Uuid();
    final message = Message(
      id: uuid.v4(),
      sourceUid: sourceUid,
      content: content,
      createdTime: DateTime.now().toUtc(),
      updatedTime: DateTime.now().toUtc(),
    );
    await LocalDatabase.instance.insert(
      "message",
      message.toJson(),
    );
    return message;
  }
}
