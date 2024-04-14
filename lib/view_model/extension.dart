import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/remote/message_remote_repo.dart';
import 'package:chat_app/repo/remote/user_remote_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension IdToMessage on String {
  Future<Message?> toMessage() async {
    final message = await MessageRemoteRepo.getMessage(this);
    if (message == null) return null;
    message.isMe = message.sourceUid == FirebaseAuth.instance.currentUser!.uid;
    return message;
  }
}

extension ResolveRoomName on Room {
  Future<String> get name async {
    if (userIds.isEmpty) return "";
    final otherSideId =
        userIds.firstWhere((e) => e != FirebaseAuth.instance.currentUser!.uid);
    final otherSideUser = await UserRemoteRepo.getUser(otherSideId);
    if (otherSideUser == null) return "";
    return otherSideUser.name;
  }
}
