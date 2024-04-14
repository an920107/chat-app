import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class MessageRemoteRepo {
  static final _db = FirebaseFirestore.instance.collection("message");

  static Future<void> createMessage(Message message) async {
    await _db.doc(message.id).set(message.toJson());
  }

  static Future<Message?> getMessage(String id) async {
    final snapshot = await _db.doc(id).get();
    if (!snapshot.exists) return null;
    return Message.fromJson(snapshot.data()!);
  }
}
