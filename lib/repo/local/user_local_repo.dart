import 'package:chat_app/model/user.dart';
import 'package:chat_app/service/local_database.dart';

abstract class UserLocalRepo {
  static Future<User?> getUser(String id) async {
    final json = await LocalDatabase.instance.query(
      "user",
      where: "id = ?",
      whereArgs: [id],
    );
    if (json.isEmpty) return null;
    return User.fromJson(json.first);
  }

  static Future<User> createUser(String id, String name) async {
    final user = User(
      id: id,
      name: name,
      createdTime: DateTime.now().toUtc(),
      updatedTime: DateTime.now().toUtc(),
    );
    await LocalDatabase.instance.insert(
      "user",
      user.toJson(),
    );
    return user;
  }
}
