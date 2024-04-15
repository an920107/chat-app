import 'dart:convert' as convert;

import 'package:chat_app/model/room.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Room sut;

  group("Room model:", () {
    setUp(() {
      sut = Room(
        id: "id",
        userIds: ["ida", "idb", "idc"],
        messageIds: ["msga", "msgb", "msgc"],
        createdTime: DateTime.now().toUtc(),
        updatedTime: DateTime.now().toUtc(),
      );
    });

    test("To json", () {
      final json = sut.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json["id"], sut.id);
      expect(json["users"], sut.userIds);
      expect(json["messages"], sut.messageIds);
      expect(json["created_time"], sut.createdTime.toIso8601String());
      expect(json["updated_time"], sut.updatedTime.toIso8601String());
    });

    test("To json (sql)", () {
      final json = sut.toJson(isSql: true);
      expect(json, isA<Map<String, dynamic>>());
      expect(json["id"], sut.id);
      expect(json["users"], convert.json.encode(sut.userIds));
      expect(json["messages"], convert.json.encode(sut.messageIds));
      expect(json["created_time"], sut.createdTime.toIso8601String());
      expect(json["updated_time"], sut.updatedTime.toIso8601String());
    });

    test("From json", () {
      final json = {
        "id": sut.id,
        "users": sut.userIds,
        "messages": sut.messageIds,
        "created_time": sut.createdTime.toIso8601String(),
        "updated_time": sut.updatedTime.toIso8601String(),
      };
      final room = Room.fromJson(json);
      expect(room.id, sut.id);
      expect(room.userIds, sut.userIds);
      expect(room.messageIds, sut.messageIds);
      expect(room.createdTime, sut.createdTime);
      expect(room.updatedTime, sut.updatedTime);
    });

    test("From json (sql)", () {
      final json = {
        "id": sut.id,
        "users": convert.json.encode(sut.userIds),
        "messages": convert.json.encode(sut.messageIds),
        "created_time": sut.createdTime.toIso8601String(),
        "updated_time": sut.updatedTime.toIso8601String(),
      };
      final room = Room.fromJson(json, isSql: true);
      expect(room.id, sut.id);
      expect(room.userIds, sut.userIds);
      expect(room.messageIds, sut.messageIds);
      expect(room.createdTime, sut.createdTime);
      expect(room.updatedTime, sut.updatedTime);
    });
  });
}
