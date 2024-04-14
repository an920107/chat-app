import 'package:chat_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserRemoteRepo {
  static final _db = FirebaseFirestore.instance.collection("user");

  static Future<void> createUser(User user) async {
    await _db.doc(user.id).set(user.toJson());
  }

  static Future<User?> searchUser(String email) async {
    final snapshot = await _db.where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) return null;
    return User.fromJson(snapshot.docs.first.data());
  }
}
