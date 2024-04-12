import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalDatabase {
  static late final Database _instance;
  static Database get instance => _instance;

  static Future<void> initialize() async {
    // _instance = await openDatabase(
    //   join(await getDatabasesPath(), "chat.db"),
    //   readOnly: false,
    //   onCreate: (db, version) {
    //     db.execute('''CREATE TABLE "message" (
    //       "id"	TEXT NOT NULL UNIQUE,
    //       "source_uid"	TEXT NOT NULL,
    //       "content"	TEXT NOT NULL,
    //       "created_time"	TEXT NOT NULL,
    //       "updated_time"	TEXT NOT NULL,
    //       PRIMARY KEY("id"),
    //       FOREIGN KEY("source_uid") REFERENCES "user"("id")
    //     )''');
    //     db.execute('''CREATE TABLE "room" (
    //       "id"	TEXT NOT NULL UNIQUE,
    //       "name"	TEXT NOT NULL,
    //       "users"	TEXT NOT NULL DEFAULT [] CHECK("users" LIKE '[%]'),
    //       "messages"	TEXT NOT NULL DEFAULT [] CHECK("messages" LIKE '[%]'),
    //       "is_static"	INTEGER NOT NULL,
    //       "created_time"	TEXT NOT NULL,
    //       "updated_time"	TEXT,
    //       PRIMARY KEY("id")
    //     )''');
    //     db.execute('''CREATE TABLE "user" (
    //       "id"	TEXT NOT NULL UNIQUE,
    //       "name"	TEXT NOT NULL,
    //       "created_time"	TEXT NOT NULL,
    //       "updated_time"	TEXT NOT NULL,
    //       PRIMARY KEY("id")
    //     )''');
    //   },
    //   version: 1,
    // );

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "chat.db");

    // delete existing if any
    await deleteDatabase(path);

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(url.join("assets", "chat.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    // open the database
    _instance = await openDatabase(path, readOnly: false);
  }
}
