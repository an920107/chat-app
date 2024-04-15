import 'package:chat_app/model/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class RoomRepo {
  Future<void> createRoom(Room room);
  Future<Room?> getRoom(String roomId);
  Future<List<Room>> getRooms(String userId);
  Future<void> patchMessage(String roomId, List<String> messageIds);
  Future<Room?> queryRoom(String xId, String yId);
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
}
