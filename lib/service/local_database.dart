import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDatabase {
  static const _dbName = "chat.db";

  static late Database _instance;
  static Database get instance => _instance;

  static Future<void> initialize() async {
    _instance = await openDatabase(
      join(await getDatabasesPath(), _dbName),
      readOnly: false,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE "message" (
          "id"	TEXT NOT NULL UNIQUE,
          "source_uid"	TEXT NOT NULL,
          "content"	TEXT NOT NULL,
          "created_time"	TEXT NOT NULL,
          "updated_time"	TEXT NOT NULL,
          PRIMARY KEY("id"),
          FOREIGN KEY("source_uid") REFERENCES "user"("id")
        )''');
        db.execute('''CREATE TABLE "room" (
          "id"	TEXT NOT NULL UNIQUE,
          "users"	TEXT NOT NULL DEFAULT [],
          "messages"	TEXT NOT NULL DEFAULT [],
          "created_time"	TEXT NOT NULL,
          "updated_time"	TEXT,
          PRIMARY KEY("id")
        )''');
        db.execute('''CREATE TABLE "user" (
          "id"	TEXT NOT NULL UNIQUE,
          "name"	TEXT NOT NULL,
          "email"	TEXT NOT NULL,
          "created_time"	TEXT NOT NULL,
          "updated_time"	TEXT NOT NULL,
          PRIMARY KEY("id")
        )''');
      },
      version: 1,
    );
  }

  Future<void> clearData() async {
    await _instance.close();
    await deleteDatabase(join(await getDatabasesPath(), _dbName));
    await SystemNavigator.pop();
  }
}
