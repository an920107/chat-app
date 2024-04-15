import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/message_repo.dart';
import 'package:chat_app/repo/room_repo.dart';
import 'package:chat_app/service/message_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
    final localRoom = await RoomLocalRepo().getRoom(id);
    if (localRoom != null) {
      _room = localRoom;
      notifyListeners();
    }

    await RoomRemoteRepo().getRoom(id).then((remoteRoom) async {
      if (remoteRoom == null) throw Exception("Room not found");
      if (localRoom == null) {
        _room = remoteRoom;
        await RoomLocalRepo().createRoom(remoteRoom);
        notifyListeners();
      } else if (remoteRoom.updatedTime.compareTo(_room.updatedTime) > 0) {
        _room = remoteRoom;
        await RoomLocalRepo().updateRoom(remoteRoom);
        notifyListeners();
      }
    });
  }

  Future<void> sendMessage(String content) async {
    if (_room.id.isEmpty) throw Exception("Room not found");
    final message = Message(
      id: const Uuid().v4(),
      sourceUid: FirebaseAuth.instance.currentUser!.uid,
      content: content,
      createdTime: DateTime.now().toUtc(),
      updatedTime: DateTime.now().toUtc(),
    );
    await fetch(_room.id);
    _room.messageIds.add(message.id);
    await MessageRemoteRepo().createMessage(message);
    await RoomRemoteRepo().patchMessage(_room.id, _room.messageIds);
    MessageService.addMessage(message);
    notifyListeners();
  }
}
