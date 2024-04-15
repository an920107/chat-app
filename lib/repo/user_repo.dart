import 'package:chat_app/model/user.dart';
import 'package:chat_app/service/local_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class UserRepo {
  Future<void> createUser(User user);
  Future<User?> getUser(String id);
  Future<User?> searchUser(String email);
  Future<void> updateUser(User user);
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

  @override
  Future<void> updateUser(User user) async {
    await _db.doc(user.id).update(user.toJson());
  }
}

class UserLocalRepo implements UserRepo {
  static final UserLocalRepo _instance = UserLocalRepo._internal();
  factory UserLocalRepo() => _instance;
  UserLocalRepo._internal();

  @override
  Future<void> createUser(User user) async {
    await LocalDatabase.instance.insert("user", user.toJson(isSql: true));
  }

  @override
  Future<User?> getUser(String id) async {
    final json = await LocalDatabase.instance.query(
      "user",
      where: "id = ?",
      whereArgs: [id],
    );
    if (json.isEmpty) return null;
    return User.fromJson(json.first, isSql: true);
  }

  @override
  Future<User?> searchUser(String email) async {
    final json = await LocalDatabase.instance.query(
      "user",
      where: "email = ?",
      whereArgs: [email],
    );
    if (json.isEmpty) return null;
    return User.fromJson(json.first, isSql: true);
  }

  @override
  Future<void> updateUser(User user) async {
    await LocalDatabase.instance.update(
      "user",
      user.toJson(isSql: true),
      where: "id = ?",
      whereArgs: [user.id],
    );
  }
}
