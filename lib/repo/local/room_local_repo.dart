import 'dart:convert' as convert;

import 'package:chat_app/model/room.dart';
import 'package:chat_app/service/local_database.dart';

abstract class RoomLocalRepo {
  static Future<List<Room>> getRooms() async {
    final json = await LocalDatabase.instance.query(
      "room",
      orderBy: "updated_time DESC",
    );
    return json.map((e) => Room.fromJson(e)).toList();
  }

  static Future<Room?> getRoom(String id) async {
    final json = await LocalDatabase.instance.query(
      "room",
      where: "id = ?",
      whereArgs: [id],
    );
    if (json.isEmpty) return null;
    return Room.fromJson(json.first);
  }

  static Future<void> patchMessage(String roomId, List<String> messageIds) async {
    await LocalDatabase.instance.update(
      "room",
      {
        "messages": convert.json.encode(messageIds),
        "updated_time": DateTime.now().toUtc().toIso8601String(),
      },
      where: "id = ?",
      whereArgs: [roomId],
    );
  }
}
