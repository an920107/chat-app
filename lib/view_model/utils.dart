import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/message_repo.dart';
import 'package:chat_app/repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Utils {
  static final Utils _instance = Utils._internal();
  factory Utils() => _instance;
  Utils._internal();

  Future<Message?> getMessage(String? id) async {
    if (id == null) return null;
    var message = await MessageLocalRepo().getMessage(id);
    if (message == null) {
      message = await MessageRemoteRepo().getMessage(id);
      if (message == null) return null;
      await MessageLocalRepo().createMessage(message);
    }
    message.isMe = message.sourceUid == FirebaseAuth.instance.currentUser!.uid;
    return message;
  }

  Future<String> getRoomName(Room room) async {
    if (room.userIds.isEmpty) return "";
    final otherSideId = room.userIds
        .firstWhere((e) => e != FirebaseAuth.instance.currentUser!.uid);
    var otherSideUser = await UserLocalRepo().getUser(otherSideId);
    if (otherSideUser == null) {
      otherSideUser = await UserRemoteRepo().getUser(otherSideId);
      if (otherSideUser == null) return "";
      await UserLocalRepo().createUser(otherSideUser);
    }
    return otherSideUser.name;
  }
}
