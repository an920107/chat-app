import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/local/message_local_repo.dart';
import 'package:chat_app/repo/local/room_local_repo.dart';
import 'package:chat_app/service/message_service.dart';
import 'package:flutter/material.dart';

class ChatRoomPageViewModel with ChangeNotifier {
  Room _room = Room(
    id: "",
    userIds: [],
    messageIds: [],
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

  Future<void> sendMessage(String content) async {
    if (_room.id.isEmpty) throw Exception("Room not found");
    // TODO: user id
    final message = await MessageLocalRepo.createMessage(
        "6b38a418-5ada-4c69-8cac-6354d74b4811", content);
    _room.messageIds.add(message.id);
    await RoomLocalRepo.patchMessage(_room.id, _room.messageIds);
    MessageService.addMessage(message);
    notifyListeners();
  }
}
