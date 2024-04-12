class User {
  String id;
  String name;
  DateTime createdTime;
  DateTime updatedTime;

  User({
    required this.id,
    required this.name,
    required this.createdTime,
    required this.updatedTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      createdTime: DateTime.parse(json["created_time"]),
      updatedTime: DateTime.parse(json["updated_time"]),
    );
  }
}
