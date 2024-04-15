import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class MessageRepo {
  Future<void> createMessage(Message message);
  Future<Message?> getMessage(String id);
}

class MessageRemoteRepo implements MessageRepo {
  static final MessageRemoteRepo _instance = MessageRemoteRepo._internal();
  factory MessageRemoteRepo() => _instance;
  MessageRemoteRepo._internal();

  static final _db = FirebaseFirestore.instance.collection("message");
  
  @override
  Future<void> createMessage(Message message) async {
    await _db.doc(message.id).set(message.toJson());
  }
  
  @override
  Future<Message?> getMessage(String id) async {
    final snapshot = await _db.doc(id).get();
    if (!snapshot.exists) return null;
    return Message.fromJson(snapshot.data()!);
  }
}
