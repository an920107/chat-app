import 'dart:convert' as convert;

import 'package:chat_app/model/room.dart';
import 'package:chat_app/service/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class RoomRepo {
  Future<void> createRoom(Room room);
  Future<Room?> getRoom(String roomId);
  Future<List<Room>> getRooms(String userId);
  Future<void> patchMessage(String roomId, List<String> messageIds);
  Future<Room?> queryRoom(String xId, String yId);
  Future<void> updateRoom(Room room);
}

class RoomRemoteRepo extends RoomRepo {
  static final RoomRemoteRepo _instance = RoomRemoteRepo._internal();
  factory RoomRemoteRepo() => _instance;
  RoomRemoteRepo._internal();

  static final _db = FirebaseFirestore.instance.collection("room");

  @override
  Future<void> createRoom(Room room) async {
    await _db.doc(room.id).set(room.toJson());
  }

  @override
  Future<Room?> getRoom(String roomId) async {
    final snapshot = await _db.doc(roomId).get();
    if (!snapshot.exists) return null;
    return Room.fromJson(snapshot.data()!);
  }

  @override
  Future<List<Room>> getRooms(String userId) async {
    final snapshot = await _db.where("users", arrayContains: userId).get();
    return snapshot.docs.map((e) => Room.fromJson(e.data())).toList();
  }

  @override
  Future<void> patchMessage(String roomId, List<String> messageIds) async {
    await _db.doc(roomId).update(
      {
        "messages": messageIds,
        "updated_time": DateTime.now().toUtc().toIso8601String(),
      },
    );
  }

  @override
  Future<Room?> queryRoom(String xId, String yId) async {
    final xSnapshot = await _db.where("users", arrayContains: xId).get();
    if (xSnapshot.docs.isEmpty) return null;
    final ySnapshot = await _db.where("users", arrayContains: yId).get();
    if (ySnapshot.docs.isEmpty) return null;

    final xRooms = xSnapshot.docs.map((e) => Room.fromJson(e.data()));
    final yRooms = ySnapshot.docs.map((e) => Room.fromJson(e.data()));
    return xRooms.where((x) => yRooms.any((y) => x.id == y.id)).firstOrNull;
  }

  @override
  Future<void> updateRoom(Room room) async {
    await _db.doc(room.id).update(room.toJson());
  }
}

class RoomLocalRepo extends RoomRepo {
  static final RoomLocalRepo _instance = RoomLocalRepo._internal();
  factory RoomLocalRepo() => _instance;
  RoomLocalRepo._internal();

  @override
  Future<void> createRoom(Room room) async {
    await LocalDatabase.instance.insert("room", room.toJson(isSql: true));
  }

  @override
  Future<Room?> getRoom(String roomId) async {
    final json = await LocalDatabase.instance.query(
      "room",
      where: "id = ?",
      whereArgs: [roomId],
    );
    if (json.isEmpty) return null;
    return Room.fromJson(json.first, isSql: true);
  }

  @override
  Future<List<Room>> getRooms(String userId) async {
    final json = await LocalDatabase.instance.query(
      "room",
      orderBy: "updated_time DESC",
    );
    return json
        .map((e) => Room.fromJson(e, isSql: true))
        .where((e) => e.userIds.contains(userId))
        .toList();
  }

  @override
  Future<void> patchMessage(String roomId, List<String> messageIds) async {
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

  @override
  Future<Room?> queryRoom(String xId, String yId) {
    // TODO: implement queryRoom
    throw UnimplementedError();
  }

  @override
  Future<void> updateRoom(Room room) async {
    await LocalDatabase.instance.update(
      "room",
      room.toJson(isSql: true),
      where: "id = ?",
      whereArgs: [room.id],
    );
  }
}
