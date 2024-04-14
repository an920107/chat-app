import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/local/message_local_repo.dart';
import 'package:chat_app/repo/remote/user_remote_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension IdToMessage on String {
  Future<Message> toMessage() async {
    final message = await MessageLocalRepo.getMessage(this);
    if (message == null) throw Exception("Message not found");
    // TODO: user id
    message.isMe = message.sourceUid == "6b38a418-5ada-4c69-8cac-6354d74b4811";
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
