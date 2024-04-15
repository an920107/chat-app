import 'package:chat_app/model/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late User sut;

  group("User model:", () {
    setUp(() {
      sut = User(
        id: "id",
        name: "name",
        email: "user@example.com",
        createdTime: DateTime.now().toUtc(),
        updatedTime: DateTime.now().toUtc(),
      );
    });

    test("To json", () {
      final json = sut.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json["id"], sut.id);
      expect(json["name"], sut.name);
      expect(json["email"], sut.email);
      expect(json["created_time"], sut.createdTime.toIso8601String());
      expect(json["updated_time"], sut.updatedTime.toIso8601String());
    });

    test("From json", () {
      final json = {
        "id": sut.id,
        "name": sut.name,
        "email": sut.email,
        "created_time": sut.createdTime.toIso8601String(),
        "updated_time": sut.updatedTime.toIso8601String(),
      };
      final user = User.fromJson(json);
      expect(user.id, sut.id);
      expect(user.name, sut.name);
      expect(user.email, sut.email);
      expect(user.createdTime, sut.createdTime);
      expect(user.updatedTime, sut.updatedTime);
    });
  });
}
