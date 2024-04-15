import 'package:chat_app/model/message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Message sut;

  group("Message model:", () {
    setUp(() {
      sut = Message(
        id: "id",
        sourceUid: "uid",
        content: "content",
        createdTime: DateTime.now().toUtc(),
        updatedTime: DateTime.now().toUtc(),
      );
    });

    test("To json", () {
      final json = sut.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json["id"], sut.id);
      expect(json["source_uid"], sut.sourceUid);
      expect(json["content"], sut.content);
      expect(json["created_time"], sut.createdTime.toIso8601String());
      expect(json["updated_time"], sut.updatedTime.toIso8601String());
    });

    test("From json", () {
      final json = {
        "id": sut.id,
        "source_uid": sut.sourceUid,
        "content": sut.content,
        "created_time": sut.createdTime.toIso8601String(),
        "updated_time": sut.updatedTime.toIso8601String(),
      };
      final message = Message.fromJson(json);
      expect(message.id, sut.id);
      expect(message.sourceUid, sut.sourceUid);
      expect(message.content, sut.content);
      expect(message.createdTime, sut.createdTime);
      expect(message.updatedTime, sut.updatedTime);
    });
  });
}
