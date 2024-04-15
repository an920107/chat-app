import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/message_repo.dart';
import 'package:chat_app/repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension IdToMessage on String {
  Future<Message?> toMessage() async {
    var message = await MessageLocalRepo().getMessage(this);
    if (message == null) {
      message = await MessageRemoteRepo().getMessage(this);
      if (message == null) return null;
      await MessageLocalRepo().createMessage(message);
    }
    message.isMe = message.sourceUid == FirebaseAuth.instance.currentUser!.uid;
    return message;
  }
}

extension ResolveRoomName on Room {
  Future<String> get name async {
    if (userIds.isEmpty) return "";
    final otherSideId =
        userIds.firstWhere((e) => e != FirebaseAuth.instance.currentUser!.uid);
    var otherSideUser = await UserLocalRepo().getUser(otherSideId);
    if (otherSideUser == null) {
      otherSideUser = await UserRemoteRepo().getUser(otherSideId);
      if (otherSideUser == null) return "";
      await UserLocalRepo().createUser(otherSideUser);
    }
    return otherSideUser.name;
  }
}
