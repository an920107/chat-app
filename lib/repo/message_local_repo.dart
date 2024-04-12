import 'package:chat_app/model/message.dart';
import 'package:chat_app/service/local_database.dart';

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
}
