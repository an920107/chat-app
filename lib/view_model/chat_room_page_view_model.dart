import 'package:chat_app/model/message.dart';
import 'package:chat_app/model/room.dart';
import 'package:chat_app/repo/message_repo.dart';
import 'package:chat_app/repo/open_ai_repo.dart';
import 'package:chat_app/repo/room_repo.dart';
import 'package:chat_app/service/message_service.dart';
import 'package:chat_app/view_model/utils.dart';
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

  bool _sendMessageLock = false;
  bool get sendMessageLock => _sendMessageLock;

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;    

    _sendMessageLock = true;
    notifyListeners();

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

    if (!Utils().isAiRoom(_room)) {
      _sendMessageLock = false;
      notifyListeners();
      return;
    }
    final aiReply = await OpenAiRepo().getReply(content);
    if (aiReply == null) {
      _sendMessageLock = false;
      notifyListeners();
      return;
    }
    final aiMessage = Message(
      id: const Uuid().v4(),
      sourceUid: "ai",
      content: aiReply,
      createdTime: DateTime.now().toUtc(),
      updatedTime: DateTime.now().toUtc(),
    );
    _room.messageIds.add(aiMessage.id);
    await MessageRemoteRepo().createMessage(aiMessage);
    await RoomRemoteRepo().patchMessage(_room.id, _room.messageIds);
    MessageService.addMessage(aiMessage);
    _sendMessageLock = false;
    notifyListeners();
  }
}
