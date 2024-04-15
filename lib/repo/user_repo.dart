import 'package:chat_app/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class UserRepo {
  Future<void> createUser(User user);
  Future<User?> getUser(String id);
  Future<User?> searchUser(String email);
}

class UserRemoteRepo implements UserRepo {
  static final UserRemoteRepo _instance = UserRemoteRepo._internal();
  factory UserRemoteRepo() => _instance;
  UserRemoteRepo._internal();

  static final _db = FirebaseFirestore.instance.collection("user");
  
  @override
  Future<void> createUser(User user) async {
    await _db.doc(user.id).set(user.toJson());
  }
  
  @override
  Future<User?> getUser(String id) async {
    final snapshot = await _db.doc(id).get();
    if (!snapshot.exists) return null;
    return User.fromJson(snapshot.data()!);
  }
  
  @override
  Future<User?> searchUser(String email) async {
    final snapshot = await _db.where("email", isEqualTo: email).get();
    if (snapshot.docs.isEmpty) return null;
    return User.fromJson(snapshot.docs.first.data());
  }
}
