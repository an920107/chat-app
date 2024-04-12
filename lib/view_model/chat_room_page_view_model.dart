import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/message_local_repo.dart';
import 'package:chat_app/repo/room_local_repo.dart';
import 'package:flutter/material.dart';

class ChatRoomPageViewModel with ChangeNotifier {
  Room _room = Room(
    id: "",
    name: "Loading...",
    userIds: [],
    messageIds: [],
    isStatic: true,
    createdTime: DateTime.fromMillisecondsSinceEpoch(0),
    updatedTime: DateTime.fromMillisecondsSinceEpoch(0),
  );
  Room get room => _room;

  Future<void> fetch(String id) async {
    await RoomLocalRepo.getRoom(id).then((value) {
      if (value == null) throw Exception("Room not found");
      _room = value;
    });
    notifyListeners();
  }
}

extension IdToMessage on String {
  Future<Message> toMessage() async {
    final message = await MessageLocalRepo.getMessage(this);
    if (message == null) throw Exception("Message not found");
    /// TODO: user id
    message.isMe = message.sourceUid == "6b38a418-5ada-4c69-8cac-6354d74b4811";
    return message;
  }
}