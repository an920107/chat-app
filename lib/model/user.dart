class User {
  String id;
  String name;
  String email;
  DateTime createdTime;
  DateTime updatedTime;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdTime,
    required this.updatedTime,
  });

  factory User.fromJson(
    Map<String, dynamic> json, {
    bool isSql = false,
  }) =>
      User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        createdTime: DateTime.parse(json["created_time"]),
        updatedTime: DateTime.parse(json["updated_time"]),
      );

  Map<String, dynamic> toJson({bool isSql = false}) => {
        "id": id,
        "name": name,
        "email": email,
        "created_time": createdTime.toIso8601String(),
        "updated_time": updatedTime.toIso8601String(),
      };
}
