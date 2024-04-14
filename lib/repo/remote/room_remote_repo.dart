import 'package:chat_app/model/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RoomRemoteRepo {
  static final _db = FirebaseFirestore.instance.collection("room");

  static Future<List<Room>> getRooms(String userId) async {
    final snapshot = await _db.where("users", arrayContains: userId).get();
    return snapshot.docs.map((e) => Room.fromJson(e.data())).toList();
  }

  static Future<void> createRoom(Room room) async {
    await _db.doc(room.id).set(room.toJson());
  }

  static Future<Room?> queryRoom(String xId, String yId) async {
    final xSnapshot = await _db.where("users", arrayContains: xId).get();
    if (xSnapshot.docs.isEmpty) return null;
    final ySnapshot = await _db.where("users", arrayContains: yId).get();
    if (ySnapshot.docs.isEmpty) return null;

    final xRooms = xSnapshot.docs.map((e) => Room.fromJson(e.data()));
    final yRooms = ySnapshot.docs.map((e) => Room.fromJson(e.data()));
    return xRooms.where((x) => yRooms.any((y) => x.id == y.id)).firstOrNull;
  }
}
