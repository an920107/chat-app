import 'package:chat_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserRemoteRepo {
  static final _db = FirebaseFirestore.instance.collection("user");

  static Future<void> createUser(User user) async {
    await _db.doc(user.id).set(user.toJson());
  }
}
